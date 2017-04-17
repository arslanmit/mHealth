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
            let displayname = FIRAuth.auth()?.currentUser?.displayName ?? "Not set"
            data.append(displayname)
            data.append(value?["current-lifestyle"] as! String)
            data.append(value?["desired-lifestyle"] as! String)
            self.data = data
            self.tableView.reloadData()
        })
    }
    
    func changeUserDataAlert(title: String, message: String, dataKey: String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let textField = alert.textFields![0]
                                        let id: String = Util.removePeriod(s: (self.user?.email)!)
                                        self.rootRef.child("users//\(id)/User-Data/\(dataKey)").setValue(textField.text!)
                                        self.load()
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func changeDisplayName(title: String, message: String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let textField = alert.textFields![0]
                                        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                                        changeRequest?.displayName = textField.text
                                        changeRequest?.commitChanges() { (error) in
                                            print("error is: \(error)")
                                            self.load()
                                        }
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func changeDesiredLifestyle(){
        
        let alert = UIAlertController(title: "Change current lifestyle",
                                      message: "Enter new lifestyle",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let textField = alert.textFields![0]
                                        let id: String = Util.removePeriod(s: (self.user?.email)!)
                                        self.rootRef.child("users//\(id)/User-Data/desired-lifestyle").setValue(textField.text!)
                                        self.load()
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            let pick = DesiredLifestylePicker()
            pick.textField = textField
            pick.awakeFromNib()
            textField.inputView = pick
            textField.textAlignment = .center
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: TABLE VIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as? UserTableViewCell
        cell?.data.text = settings[indexPath.row]
        cell?.value.text = data[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.row == 0){
            changeUserDataAlert(title:"Change name", message: "Enter new name", dataKey: "name")
        }
        else if(indexPath.row == 2){
            changeDisplayName(title: "Change Display Name", message: "Enter new name")
        }
        else if(indexPath.row == 4){
            changeDesiredLifestyle()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
}


