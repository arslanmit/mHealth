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
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
 //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
 //MARK: Array of Runs
    var runs = [FirebaseRun]()

    override func viewDidLoad(){
        self.mainView.layer.cornerRadius = 5.0
        setWelcome()
        
        let id: String = Util.removePeriod(s: (user?.email)!)
        let ref = FIRDatabase.database().reference(withPath: "users//\(id)/")
        ref.observe(.value, with: { snapshot in
            self.load()
        })
    }
    
    private func load(){
        self.setWelcome()
        self.loadRuns()
    }
    
    func setProgress(){
        var distance = 0.0
        for run in runs{
            distance = distance + run.distance
        }
        progressLabel.text = "\(String(Util.getMiles(from: distance))) miles ran! "
    }
    
    func setWelcome(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let userRef = FIRDatabase.database().reference(withPath: "users//\(id)/User-Data")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let mName = value?["name"] as! String
            self.title = mName
            self.welcomeLabel.text = "Welcome, \(mName)!"
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
        })
    }

}
