//
//  TestViewController.swift
//  mHealth
//
//  Created by Loaner on 3/9/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import HealthKit
import Firebase

class TestViewController: UIViewController {
    
    private let kProfileUnit = 0
    private let kProfileDetail = 1
    
    var healthStore: HKHealthStore?
    
    private var userProfiles: [ProfileKeys: [String]]?
    
    @IBOutlet weak var requestButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func requestDidTouch(_ sender: Any) {
        
        // Set up an HKHealthStore, asking the user for read/write permissions. The profile view controller is the
        // first view controller that's shown to the user, so we'll ask for all of the desired HealthKit permissions now.
        // In your own app, you should consider requesting permissions the first time a user wants to interact with
        // HealthKit data.
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HK UNAVAILABLE!!!")
            return
        }
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            DispatchQueue.main.async{
                
                // Update the user interface based on the current user's health information.
                self.printAge()
            }
        }
        
        if let healthStore = self.healthStore {
            
            healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes, completion: completion)
        }

    }
    
    
    
    
    func printAge(){
        
        
        var dateOfBirth: Date!
        let c = Calendar.current
        let comps: DateComponents?
        do {
            
            comps = try healthStore?.dateOfBirthComponents()
            
        } catch {
            print("Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.......")
            
            return
        }
        if(dateOfBirth != nil){
            dateOfBirth = c.date(from: (comps)!)
        }
        else{
            print("date of birth = nil")
            return
        }
        let now = Date()
        
        let ageComponents: DateComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: now)
        
        let userAge: Int = ageComponents.year!
        print(userAge)
        
        let ageValue: String = NumberFormatter.localizedString(from: userAge as NSNumber, number: NumberFormatter.Style.none)
        print(ageValue)

        
        
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
