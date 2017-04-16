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
    return isAuth
}

    
//MARK: Update Functions

    func readMostRecentSample(_ sampleType:HKSampleType , completion: ((HKSample?, NSError?) -> Void)!){
        // 1. Build the Predicate
        let past = Date.distantPast
        let now   = Date()
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: past, end:now, options: HKQueryOptions())
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
               // completion(nil,error)
                print("\(queryError)")
                return;
            }
            
            // Get the first sample
            let mostRecentSample = results?.first as? HKQuantitySample
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthStore.execute(sampleQuery)
    }
    
    
    
    
    
    



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
