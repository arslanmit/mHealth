//
//  favorite.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//
import Foundation
import Firebase

struct FoodItem {
    
    let foodName: String
    let calories: Double
    let timestamp: String
    let ref: FIRDatabaseReference?
    
    init(foodName: String, calories: Double, timestamp: String = "unavaliable") {
        self.foodName = foodName
        self.calories = calories
        self.timestamp = timestamp
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        foodName = snapshotValue["food-name"] as! String
        calories = snapshotValue["calories"] as! Double
        timestamp = snapshotValue["timestamp"] as? String ?? "unavaliable"
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "food-name":foodName,
            "calories":calories,
            "timestamp":timestamp
        ]
    }
    
}
