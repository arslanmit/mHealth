//
//  FirebaseRunsViewController.swift
//  mHealth
//
//  Created by Loaner on 3/23/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import HealthKit
import MapKit
import AudioToolbox
import Firebase
import Social

class FirebaseRunsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    //MARK: VARIABLES
    var mapOverlay: MKTileOverlay!
    var myFirebaseRun: FirebaseRun!
    
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descentLabel: UILabel!
    @IBOutlet weak var climbLabel: UILabel!
    @IBOutlet weak var caloriesBurntLabel: UILabel!

    @IBOutlet weak var twitterButton: UIButton!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureView()
    }
    
    @IBAction func twitterDidClick(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc?.setInitialText("I ran \(Util.getMiles(from: myFirebaseRun.distance)) miles using mHealth!")
        vc?.add(URL(string: "google.com"))
        present(vc!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRunPins(){
        // Drop a pin at user's start and end points
        let startRoute: MKPointAnnotation = MKPointAnnotation()
        startRoute.coordinate = CLLocationCoordinate2DMake(myFirebaseRun.latitudes.first!, myFirebaseRun.longitudes.first!);
        startRoute.title = "Started: \(Util.PinFormat(from: myFirebaseRun.timestamps.first!))"
        let endRoute: MKPointAnnotation = MKPointAnnotation()
        endRoute.coordinate = CLLocationCoordinate2DMake(myFirebaseRun.latitudes.last!, myFirebaseRun.longitudes.last!);
        endRoute.title = "Ended: \(Util.PinFormat(from: myFirebaseRun.timestamps.last!))"
        mapView.addAnnotation(startRoute)
        mapView.addAnnotation(endRoute)
    }
    

    func configureView() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
       // dateLabel.text = dateFormatter.string(from: Util.stringToDate(date: myFirebaseRun.timestamps.first!))
        self.title = dateFormatter.string(from: Util.Date(from: myFirebaseRun.timestamps.first!))
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(myFirebaseRun.duration))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        timeLabel.text = "Time: "+hoursQuantity.description+" "+minutesQuantity.description+" "+secondsQuantity.description
        
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: myFirebaseRun.distance)
        distanceLabel.text = "Total Distance: \(Util.metersToMilesString(distanceQuantity: distanceQuantity)) miles"
        
        //let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())//HKUnit.second().unitDivided(by: HKUnit.meter())
        //let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: distance / seconds)
      //  paceLabel.text = "Mean speed: "+String((myFirebaseRun.distance/myFirebaseRun.duration*3.6*10).rounded()/10)+" km/h"
        paceLabel.text = "Mean speed: \(Util.kmphToMphString(kmph: (myFirebaseRun.distance/myFirebaseRun.duration))) MPH"
        climbLabel.text = "Total climb: "+String((myFirebaseRun.climb).rounded())+" m"
        descentLabel.text = "Total descent: "+String((myFirebaseRun.descent).rounded())+" m"
        print(myFirebaseRun.caloriesBurnt)
        caloriesBurntLabel.text =  "Total Calories Burned: \((myFirebaseRun.caloriesBurnt).rounded())"
        
        loadMap()
        setRunPins()
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func mapRegion() -> MKCoordinateRegion {
        
        var minLat = myFirebaseRun.latitudes[0]
        var minLng = myFirebaseRun.longitudes[0]
        var maxLat = minLat
        var maxLng = minLng
        
        for i in 0...myFirebaseRun.latitudes.count-1 {
            minLat = min(minLat, myFirebaseRun.latitudes[i])
            minLng = min(minLng, myFirebaseRun.longitudes[i])
            maxLat = max(maxLat, myFirebaseRun.latitudes[i])
            maxLng = max(maxLng, myFirebaseRun.longitudes[i])
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                           longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                                   longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay{
            guard let tileOverlay = overlay as? MKTileOverlay else {
                print("titleOverlay != overlay")
                return MKOverlayRenderer()
            }
            print("titleOverlay == overlay")
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        if overlay is MulticolorPolylineSegment {
            let polyline = overlay as! MulticolorPolylineSegment
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 3
            print("mapView = MPSeg")
            return renderer
        }
        print("mapview function did not hit an if-statement ")
        return MKOverlayRenderer()
    }

    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        for i in 0...myFirebaseRun.latitudes.count-1 { //for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: myFirebaseRun.latitudes[i],
                                                 longitude: myFirebaseRun.longitudes[i]))
        }
        return MKPolyline(coordinates: &coords, count: myFirebaseRun.latitudes.count)
    }
    
    
    func loadMap() {
        if myFirebaseRun.latitudes.count > 0 {
            mapView.isHidden = false
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: myFirebaseRun)
            mapView.addOverlays(colorSegments)
            print("added color segment to mapView overlay")
        } else {
            // No locations were found!
            print("no locations found")
            mapView.isHidden = true
    ////
            let alertController = UIAlertController(title: "Error", message: "This run has no locations saved", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

