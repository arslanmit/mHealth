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
    //MARK: DATA LABELS
    let settings = ["Name:", "Email:", "Display Name:", "Current Lifestyle:", "Desired LifeStyle:"]
    var data = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
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
    
    func load(){
        
        let id: String = Util.removePeriod(s: (user?.email)!)
        let userRef = FIRDatabase.database().reference(withPath: "users//\(id)/User-Data")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            var data = [String]()
            data.append(value?["name"] as! String)
            data.append(value?["email"] as! String)
            let displayname = self.user?.displayName ?? "Not set"
            data.append(displayname)
            data.append(value?["current-lifestyle"] as! String)
            data.append(value?["desired-lifestyle"] as! String)
            self.data = data
            self.tableView.reloadData()
        })
    }
    
    //MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as? UserTableViewCell
        cell?.data.text = settings[indexPath.row]
        cell?.value.text = data[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
}
