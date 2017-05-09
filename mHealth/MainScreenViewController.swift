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
import BAFluidView

class MainScreenViewController : UIViewController{
 //MARK: OUTLETS
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var exampleContainerView: UIView!
    
    
 //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
 //MARK: Array of Runs
    var runs = [FirebaseRun]()
    
    var distanceGoal: Double = 0
    var milesRan: Double = 0
    var progressPercent: Double = 0
    var progress: Double = 0

    override func viewDidLoad(){

       // setWelcomeAndRating()
        
        let id: String = Util.removePeriod(s: (user?.email)!)
        let ref = FIRDatabase.database().reference(withPath: "users//\(id)/")
        ref.observe(.value, with: { snapshot in
            self.load()
        })
        setUpBackground()
    }
    var gradient = CAGradientLayer()
    
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
        self.progress = Double(miles)!/Double(goal)!
        self.progressPercent = progress
        progressLabel.text = "\(miles) miles ran! \(goal) mile goal. \((progress*100).rounded(toPlaces: 3))%"
        progressView.setProgress(Float(progress), animated: true)
        startAnimation(self)
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
    func setUpBackground() {
        
        //   if ((self.gradient) != nil) {
        self.gradient.removeFromSuperlayer()
        //self.gradient = nil
        //    }
        
        let tempLayer: CAGradientLayer = CAGradientLayer()
        tempLayer.frame = self.view.bounds
        tempLayer.colors = [UIColor(netHex: 0xB6E2FE).cgColor, UIColor(netHex: 0xB6E2FE).cgColor, UIColor(netHex: 0xDAECF7).cgColor, UIColor(netHex: 0xF3F8FB).cgColor]
        tempLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.5), NSNumber(value: 0.8), NSNumber(value: 1.0)]
        tempLayer.startPoint = CGPoint(x: 0, y: 0)
        tempLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.gradient = tempLayer
        self.backgroundView.layer.insertSublayer(self.gradient, at: 1)
        self.exampleContainerView.isHidden = true
    }
    @IBAction func startAnimation(_ sender: Any) {
        let myView:BAFluidView = BAFluidView(frame: self.view.frame, startElevation: progress as NSNumber!)
        print(progress)
        
        myView.strokeColor = UIColor.white
        // 0x2e353d
        myView.fillColor = UIColor(netHex: 0x004262)
        myView.keepStationary()
        myView.startAnimation()
        self.exampleContainerView.isHidden = false
        myView.startAnimation()
        
        self.view.insertSubview(myView, aboveSubview: self.backgroundView)
        
        UIView.animate(withDuration: 0.5, animations: {
            myView.alpha=1.0
        }, completion: { _ in
            self.exampleContainerView.removeFromSuperview()
            self.exampleContainerView = myView
        })
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

