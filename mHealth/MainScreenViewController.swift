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
 //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
//MARK: User Data

    override func viewDidLoad(){
        self.mainView.layer.cornerRadius = 5.0
        setWelcome()
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

}
