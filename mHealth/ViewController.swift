//
//  ViewController.swift
//  mHealth
//
//  Created by Loaner on 2/28/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    //MARK: Store
    let healthStore = HKHealthStore()

    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var displayField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hasKit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
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

