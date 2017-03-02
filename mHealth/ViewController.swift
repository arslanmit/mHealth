//
//  ViewController.swift
//  mHealth
//
//  Created by Loaner on 2/28/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit
import Firebase

class ViewController: UIViewController {
    
    //MARK: Store
    let healthStore = HKHealthStore()
    //MARK: Auth Outlets
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var displayField: UITextView!
    
    //MARK: Login Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    

    //Firebase Buttons
    
    @IBAction func loginDidTouch(_ sender: Any) {
        FIRAuth.auth()!.signIn(withEmail: emailField.text!,
                               password: passwordField.text!, completion: { user, error in
                                
                                if error == nil {
                                    let alert = UIAlertController(title: "Login Error...",
                                                                  message: "Please register for an account!",
                                                                  preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Okay",
                                                                 style: .default)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else{
                                    print("logged in")
                                }
        })
    }
   
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
           password: passwordField.text!) { user, error in
            if error == nil {
                let alert = UIAlertController(title: "Sign Up Error...",
                                              message: "Please login!",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "User created!",
                                              message: "Please log in now!",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hasKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    //
    @IBAction func requestButtonDidTouch(_ sender: Any) {
        
        var shareTypes = Set<HKSampleType>()
        shareTypes.insert(HKSampleType.workoutType())
        
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.workoutType())
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
            if success {
                self.displayField.text = "\(self.displayField.text) + \n Sucess!"
            } else {
                self.displayField.text = "\(self.displayField.text) + \n Failure!"
            }
            
            if let error = error { self.displayField.text = "\(error)" }
        }
    }
    
    func hasKit(){
        if (HKHealthStore.isHealthDataAvailable()){
            displayField.text = "HKHealthStore is available!"
            
        }
        else{
            displayField.text = "ERROR: Unavailable"
        }
    }
    

}

