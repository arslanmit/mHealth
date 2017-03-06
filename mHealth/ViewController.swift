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
    
    
    @IBOutlet weak var viewSpace: UIView!

    //Firebase Buttons
    
    @IBAction func loginDidTouch(_ sender: Any) {
       loginFunction()
    }
   
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                   password: passwordField.text!) { user, error in
            if error != nil { //unsucessful
                let alert = UIAlertController(title: "Create account error",
                                              message: "Please enter a valid email address. \n Please enter a password more than 6 characters in length. \n Now, please login!",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.loginFunction()
            }
        }
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewSpace.layer.cornerRadius = 5.0
        hasKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loginFunction(){
        FIRAuth.auth()!.signIn(withEmail: emailField.text!,
                               password: passwordField.text!, completion: { user, error in
                                
            if error != nil { //unsucessful
                let alert = UIAlertController(title: "Login Error...",
                                              message: "Please register for an account!",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "loginToNavigation", sender: nil)
            }
        })

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

