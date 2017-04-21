/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreMotion
import CoreData
import CoreLocation
import HealthKit
import MapKit
import AudioToolbox
import Firebase

let DetailSegueName = "RunDetails"
let HomepageSegueName = "RunToHomepageSegue"

class NewRunViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext? = nil// = appDelegate.managedObjectContext!
    var managedObjectContext: NSManagedObjectContext?
    
    var run: Run!
    var seconds = 0.0
    var distance = 0.0
    var instantPace = 0.0
    var vertClimb = 0.0
    var vertDescent = 0.0
    var previousAlt = 0.0
    var calories = 0.0
    var weight: Double?
    var locationManager: CLLocationManager!
    let activityManager = CMMotionActivityManager()
    
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()
    var mapOverlay: MKTileOverlay!
    
    @IBOutlet weak var mapView2: MKMapView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var climbLabel: UILabel!
    @IBOutlet weak var descentLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        managedContext = appDelegate.managedObjectContext!
        
        setFirebaseWeight()
        
        startButton.isHidden = false
        
        timeLabel.isHidden = true
        distanceLabel.isHidden = true
        paceLabel.isHidden = true
        climbLabel.isHidden = true
        descentLabel.isHidden = true
        caloriesLabel.isHidden = true
        stopButton.isHidden = true
        mapView2.isHidden = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        managedObjectContext = appDelegate.managedObjectContext
        startLocationUpdates()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView2.delegate = self;
        
        mapView2.showsUserLocation = true
        //pedometer status to title! :)
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data: CMMotionActivity?) -> Void in
                DispatchQueue.main.async{
                    if(data?.stationary == true){
                        self.title = "Stationary"
                    } else if (data?.walking == true){
                        self.title = "Walking"
                    } else if (data?.running == true){
                        self.title = "Running"
                    } else if (data?.automotive == true){
                        self.title = "Automotive"
                    }
                }
                
            })
            
        }
        //
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView2.userLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView2.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func startPressed(_ sender: AnyObject) {
        startButton.isHidden = true
        
        timeLabel.isHidden = false
        distanceLabel.isHidden = false
        paceLabel.isHidden = false
        climbLabel.isHidden = false
        descentLabel.isHidden = false
        caloriesLabel.isHidden = false
        stopButton.isHidden = false
        mapView2.isHidden = false
        
        seconds = 0.0
        distance = 0.0
        vertClimb = 0.0
        vertDescent = 0.0
        instantPace = 0.0
        calories = 0.0
        previousAlt = -1000
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(eachSecond(_:)),
                                     userInfo: nil,
                                     repeats: true)
        startLocationUpdates()
    }
    
    @IBAction func stopPressed(_ sender: AnyObject) {
        presentRunOptions(title: "Walk Ended!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            detailViewController.run = run
            detailViewController.caloriesBurnt = calories
        }
    }
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func eachSecond(_ timer: Timer) {
        seconds += 1
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(seconds))
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: Double(s))
        let minutesQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: Double(m))
        let hoursQuantity = HKQuantity(unit: HKUnit.hour(), doubleValue: Double(h))
        timeLabel.text = "Time: "+hoursQuantity.description+" "+minutesQuantity.description+" "+secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        
        let dist: Double = (Double(distanceQuantity.description.replacingOccurrences(of: " m", with: "")))!*0.00062137
        let distString: String = String(format: "%.2f", ceil(dist*100)/100)
        
        distanceLabel.text = "Distance: \(distString) mi"
        
        print("Distance: \((Double(distanceQuantity.description.replacingOccurrences(of: " m", with: "")))!*0.62137)")

        let paceDouble: Double = (((instantPace*3.6*10).rounded()/10)*0.62137)
        let paceString: String = String(format: "%.2f", ceil(paceDouble*100)/100)
        
        paceLabel.text = "Current speed: \(paceString) mph"//"Pace: "+String((distance/seconds*3.6*10).rounded()/10)+" km/h"
        
        climbLabel.text = "Climb: "+String((vertClimb*10).rounded()/10)+" m"
        descentLabel.text = "Descent: "+String((vertDescent*10).rounded()/10)+" m"
 ///
        
        //print(weightInPounds)
        caloriesLabel.text = "Calories: "+String(Double(weight!*0.75*dist).rounded()/100)
        calories = Double(weight!*0.75*dist/100)
        
///
    }
    
    func setFirebaseWeight(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let userRef = FIRDatabase.database().reference(withPath: "users//\(id)/User-Data")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.weight = (value?["weight"] as! Double)*2.2
        })
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
        print("start location update")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    instantPace = location.distance(from: self.locations.last!)/(location.timestamp.timeIntervalSince(self.locations.last!.timestamp))

                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView2.setRegion(region, animated: true)
                    
                    mapView2.add(MKPolyline(coordinates: &coords, count: coords.count))
                    
                    if previousAlt == -1000{
                        previousAlt = location.altitude
                    }
                    if previousAlt < location.altitude{
                        vertClimb += location.altitude-previousAlt
                    }
                    if previousAlt > location.altitude{
                        vertDescent += previousAlt-location.altitude
                    }
                    previousAlt=location.altitude
                }
                
                //save location
                self.locations.append(location)
            }
        }
        
    }
    func centerMapOnLocation(location: CLLocation, distance: CLLocationDistance) {
        let regionRadius = distance
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView2.setRegion(coordinateRegion, animated: true)
    }
    
    
 
    func saveRun() {
        // 1
        let savedRun = NSEntityDescription.insertNewObject(forEntityName: "Run",
                                                           into: managedObjectContext!) as! Run
        savedRun.distance = NSNumber(value: distance)
        savedRun.duration = (NSNumber(value: seconds))
        savedRun.timestamp = NSDate() as Date
        savedRun.climb = NSNumber(value: vertClimb)
        savedRun.descent = NSNumber(value: vertDescent)
        
        // 2
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObject(forEntityName: "Location",
                                                                    into: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = NSNumber(value: location.coordinate.latitude)
            savedLocation.longitude = NSNumber(value: location.coordinate.longitude)
            savedLocations.append(savedLocation)
        }
        
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun
        
        if(savedLocations.last?.timestamp == nil || savedLocations.first == nil || savedRun.distance == 0){
            print("NO DATA SAVED TO Firebase... avoiding errors by skipping Firebase save")
            print("note: error had been already handled in the next view controller...")
        }else{
            let dateString = Util.FirebaseTitle(from: (savedLocations.last?.timestamp)!) 
            let id: String = Util.removePeriod(s: (user?.email)!)
            let thisRun: FirebaseRun = FirebaseRun(run: run, savedLocations: savedLocations, caloriesBurnt: calories)
            self.rootRef.child("users//\(id)/Runs/\(dateString)").setValue(thisRun.toAnyObject())
        }
        
 
        do{
            try managedObjectContext!.save()
        }catch{
            print("Could not save the run!")
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    func playSuccessSound() {
        let soundURL = Bundle.main.url(forResource: "success", withExtension: "wav")
        var soundID : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as! CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
        
        //also vibrate
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }
    
}

// MARK: UIActionSheetDelegate
extension NewRunViewController: UIAlertViewDelegate {
    func presentRunOptions(title: String){
        let alertController = UIAlertController(title: title, message: "You have clicked stop.", preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save Run?", style: .default){
            (action: UIAlertAction) in
            self.saveRun()
            print("saved run clicked")
            self.locationManager.stopUpdatingLocation()
            self.performSegue(withIdentifier: DetailSegueName, sender: nil)
        }
        let deleteAction = UIAlertAction(title:"Discard Run?",  style: .default){
            (action:UIAlertAction) in
            print("disgarded run clicked")
            self.locationManager.stopUpdatingLocation()
            // refreshing view
            self.mapView2.removeOverlays(self.mapView2.overlays)
            self.viewWillDisappear(true)
            self.viewWillAppear(true)
            self.viewDidAppear(true)
            self.viewDidLoad()
         // _ = self.navigationController?.popViewController(animated: true) --- not working because it's a tab now
        }
        let cancelAction = UIAlertAction(title:"Cancel",  style: .cancel){
            (action:UIAlertAction) in
            print("canceled run option clicked")
        }
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
