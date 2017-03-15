//
//  HealthManager.swift
//  HealthKitTests
//
//  Created by Loaner on 3/10/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import HealthKit

//Authorize HealthKit
class HealthManager{
    
    var shareTypes: Set<HKSampleType>!
    var readTypes: Set<HKObjectType>!
    
    
    var healthStore = HKHealthStore()
    
    
    
func authorizeHealthKit() -> Bool{
    
    var isAuth: Bool = true
    //information request types
    shareTypes = dataTypesToWrite()
    readTypes = dataTypesToRead()
    
    
    //availablity check:
    if HKHealthStore.isHealthDataAvailable(){
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
            if success {
                print("success")
                isAuth = true
            } else {
                print("failure")
                isAuth = false
            }
            
            if let error = error { print(error) }
        }
    }
    else{
        print("HealthKit is unavailable on this device!")
        isAuth = false
    }
    
        //checks access
           //
       // DispatchQueue.main.async{
            
            /*/ Update the user interface based on the current user's health information.
            self.updateUserAge()
            self.updateUsersHeight()
            self.updateUsersWeight() */
    return isAuth
}

    
//MARK: Update Functions
    
    
    
    
    
    
    
    
    
    



//MARK: GET HEALTHKIT SETS
func dataTypesToWrite() -> Set<HKSampleType> {
    
    let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
    let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
    let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
    
    let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
    
    return writeDataTypes
}

func dataTypesToRead() -> Set<HKObjectType> {
    
    let dietaryCalorieEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
    let activeEnergyBurnType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    let heightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
    let weightType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
    let birthdayType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
    let biologicalSexType = HKQuantityType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
    let bloodType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
    
    let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType, bloodType]
    
    return readDataTypes
}

}
