//
//  SettingsViewController.swift
//  mHealth
//
//  Created by Loaner on 4/13/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //MARK: OUTLETS
    @IBOutlet weak var requestHealthKitButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK: HEALTHKIT
    private var HealthKitStore = HKHealthStore()
    private var myManager: HealthManager = HealthManager()
    //MARK: FIREBASE
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestButtonDidTouch(_ sender: Any) {
        print(myManager.authorizeHealthKit())
    }
    
    @IBAction func logoutButtonDidTouch(_ sender: Any) {
        logoutFunction()
    }
    
    func logoutFunction(){
        if (FIRAuth.auth()?.currentUser != nil) {
            do {
                try FIRAuth.auth()?.signOut()
                self.dismiss(animated: true, completion: nil)
                //   self.performSegue(withIdentifier: "welcomeToLogin", sender: nil) --- unneeded because dismissal sends back to login! :)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as? UserTableViewCell
        cell?.data.text = "data"
        cell?.value.text = "value"
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
}
