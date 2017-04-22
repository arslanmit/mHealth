//
//  MainScreenViewController.swift
//  mHealth
// >>>>>>>>>>>>> this view is so small, yet it has the most spagghetti
//  Created by Loaner on 4/3/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainScreenViewController : UIViewController{
 //MARK: OUTLETS
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
 //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
 //MARK: Array of Runs
    var runs = [FirebaseRun]()
    
    var distanceGoal: Double = 0
    var milesRan: Double = 0
    var progressPercent: Double = 0

    override func viewDidLoad(){

       // setWelcomeAndRating()
        
        let id: String = Util.removePeriod(s: (user?.email)!)
        let ref = FIRDatabase.database().reference(withPath: "users//\(id)/")
        ref.observe(.value, with: { snapshot in
            self.load()
        })
        backgroundView.layer.cornerRadius=5.0;
    }
    
    private func load(){
        self.setWelcomeAndRating()
        self.setDistanceGoal()
        self.loadRuns()
    }
    
    func setProgress(){
        var distance = 0.0
        for run in runs{
            distance = distance + run.distance
        }
        let miles: String = String(Util.getMiles(from: distance))
        milesRan = miles.doubleValue!
        let goal: String = String(self.distanceGoal)
        let progress: Double = Double(miles)!/Double(goal)!
        self.progressPercent = progress
        progressLabel.text = "\(miles) miles ran! \(goal) mile goal. \((progress*100).rounded(toPlaces: 3))%"
        progressView.setProgress(Float(progress), animated: true)
    }
    
    func setWelcomeAndRating(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let userRef = FIRDatabase.database().reference(withPath: "users//\(id)/User-Data")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let mName = value?["name"] as! String
            let currentLifestyleString = value?["current-lifestyle"] as! String
            self.title = mName
            self.welcomeLabel.text = "Welcome \(mName)"
            let cLenum: currentLifestyle = currentLifestyle(rawValue: currentLifestyleString)
            self.ratingLabel.text = "Your mHealth: \(currentLifestyleString)... \(cLenum.emoji)"
        })
    }
    
    func setDistanceGoal(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let userRef = FIRDatabase.database().reference(withPath: "users//\(id)/User-Data")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let distanceGoal = value?["distance-goal"] as! Double
            self.distanceGoal = distanceGoal
        })
    }
    
    private func loadRuns(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath: "users//\(id)/Runs/")
        runRef.observe(.value, with: { snapshot in
            var currentRuns = [FirebaseRun]()
            for run in snapshot.children{
                let oldRun = FirebaseRun(snapshot: run as! FIRDataSnapshot)
                currentRuns.append(oldRun)
            }
            currentRuns.sort(by: { Util.Date(from: $0.timestamp).compare(Util.Date(from: $1.timestamp)) == ComparisonResult.orderedAscending})
            self.runs = currentRuns;
            self.setProgress()
            self.setDistanceGoal()
            self.updateLifestyle()
        })
    }
    
    private func setLife(d: Double, dg: Double) -> (Double, currentLifestyle){
        let percent: Double = (d/dg)*100
        var life: currentLifestyle = .NotFit
        
        switch(percent){
        case _ where (percent >= 125):
            life = .VeryFit
        case _ where (percent >= 100):
            life = .Fit
        case _ where (percent >= 50):
            life = .LittleFit
        case _ where (percent < 50):
            life = .NotFit
        default:
            break
        }
        print("You've reached \(percent)% of your goal------")
        return (percent.rounded(toPlaces: 3), life)
    }
    
    private func updateLifestyle(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let (_, current) = setLife(d: milesRan, dg: distanceGoal)
        self.ref.child("users//\(id)/User-Data/current-lifestyle").setValue(current.description)
    }

}
