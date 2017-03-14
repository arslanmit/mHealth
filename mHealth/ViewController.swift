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
        self.performSegue(withIdentifier: "createAccountSegue", sender: nil)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.text = "login@login.com"
        passwordField.text = "myPassword"
        // Do any additional setup after loading the view, typically from a nib.
        self.viewSpace.layer.cornerRadius = 5.0
        hasKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
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
                self.performSegue(withIdentifier: "loginToTab", sender: nil)
            }
        })

    }

    //
    @IBAction func requestButtonDidTouch(_ sender: Any) {
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
        healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { (success, error) -> Void in
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
    
    private func dataTypesToWrite() -> Set<HKSampleType> {
        
        let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
        
        return writeDataTypes
    }
    
    private func dataTypesToRead() -> Set<HKObjectType> {
        
        let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let birthdayType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let biologicalSexType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType]
        
        return readDataTypes
    }
}

