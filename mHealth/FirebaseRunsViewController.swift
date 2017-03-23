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

class FirebaseRunsViewController: UIViewController {
    //MARK: VARIABLES
    var mapOverlay: MKTileOverlay!
    var myFirebaseRun: FirebaseRun!
    
    
    //MARK: OUTLETS
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: FIREBASE
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func fireDidClick(_ sender: Any) {
        //configureView()
        
        getRunTest()
        
        myFirebaseRun?.toString()
    
    }
    
    func getRunTest(){
        /// turn run data into Firebase Type of Run....
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath:"users//\(id)/User-Data/Last-Run/")
        
        // var oldRun: FirebaseRun?
        runRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for run in snapshot.children{
                let oldRun = FirebaseRun(snapshot: run as! FIRDataSnapshot)
                self.myFirebaseRun = oldRun;
            }
        })
        
    }

    func configureView() {
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: run.timestamp)
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(run.duration.doubleValue))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        timeLabel.text = "Time: "+hoursQuantity.description+" "+minutesQuantity.description+" "+secondsQuantity.description
        
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: run.distance.doubleValue)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        //let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())//HKUnit.second().unitDivided(by: HKUnit.meter())
        //let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: distance / seconds)
        paceLabel.text = "Mean speed: "+String((run.distance.doubleValue/run.duration.doubleValue*3.6*10).rounded()/10)+" km/h"
        
        climbLabel.text = "Total climb: "+String((run.climb.doubleValue).rounded())+" m"
        descentLabel.text = "Total descent: "+String((run.descent.doubleValue).rounded())+" m"
        */
        
        loadMap()
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func mapRegion() -> MKCoordinateRegion {
        //let initialLoc = run.locations.firstObject as! Location
        
        var minLat = myFirebaseRun.latitudes[0]
        var minLng = myFirebaseRun.longitudes[0]
        var maxLat = minLat
        var maxLng = minLng
        
       // let locations = run.locations.array as! [Location]
        
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
        //print("hello")
        if overlay is MKTileOverlay{
            guard let tileOverlay = overlay as? MKTileOverlay else {
                return MKOverlayRenderer()
            }
            
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        if overlay is MulticolorPolylineSegment {
            let polyline = overlay as! MulticolorPolylineSegment
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
     //   let locations = run.locations.array as! [Location]
        for i in 0...myFirebaseRun.latitudes.count-1 { //for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: myFirebaseRun.latitudes[i],
                                                 longitude: myFirebaseRun.longitudes[i]))
        }
        
        return MKPolyline(coordinates: &coords, count: myFirebaseRun.latitudes.count)
    }
    func loadMap() {
        if myFirebaseRun.latitudes.count > 0 {
            mapView.isHidden = false
            let template = "https://api.mapbox.com/styles/v1/spitfire4466/citl7jqwe00002hmwrvffpbzt/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic3BpdGZpcmU0NDY2IiwiYSI6Im9jX0JHQUUifQ.2QarbK_LccnrvDg7FobGjA"
            
            mapOverlay = MKTileOverlay(urlTemplate: template)
            mapOverlay.canReplaceMapContent = true
            
            mapView.add(mapOverlay,level: .aboveLabels)
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: myFirebaseRun)
            mapView.addOverlays(colorSegments)
        } else {
            // No locations were found!
            mapView.isHidden = true
            
            UIAlertView(title: "Error",
                        message: "Sorry, this run has no locations saved",
                        delegate:nil,
                        cancelButtonTitle: "OK").show()
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
