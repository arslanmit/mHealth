//
//  mHealthUser.swift
//  mHealth
//
//  Created by Loaner on 3/15/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase

enum currentLifestyle : String {
    case NotFit = "Not Fit"
    case LittleFit = "Little Fit"
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    init(rawValue: String) {
        switch rawValue {
        case "Not Fit": self = .NotFit
        case "Little Fit": self = .LittleFit
        case "Fit": self = .Fit
        case "Very Fit": self = .VeryFit
        default: self = .NotFit
        }
    }
    
    var description: String {
        return self.rawValue
    }
    
    var emoji: String{
        switch(self){
            case .NotFit:
                return "💩"
            case .LittleFit:
                return "🤕"
            case .Fit:
                return "😎"
            case .VeryFit:
                return "😈"
            default:
                break
        }
    }
}

enum desiredLifestyle : String {
    case LittleFit = "Little Fit"
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    var description: String {
        return self.rawValue
    }
}


struct mHealthUser{
    
    let uid: String
    let email: String
    let name: String
    let age: Int?
    let sex: String?
    let bloodType: String?
    let weight: Double?
    let height: Double?
    let bmi: Double?
    let mcurrentLifestyle: currentLifestyle
    let mdesiredLifestyle: desiredLifestyle
    let distanceGoal: Double?
    
    
    let ref: FIRDatabaseReference?

    init(uid: String,
         email: String,
         name: String = " ",
         age: Int = 0,
         sex: String? = nil,
         bloodType: String? = nil,
         weight: Double? = nil,
         height: Double? = nil,
         bmi: Double? = nil,
         mcurrentLifestyle: String, mdesiredLifestyle: String,
         distanceGoal: Double? = nil) {
        self.uid = uid
        self.email = email
        self.name = name
        self.age = age
        self.sex = sex
        self.bloodType = bloodType
        self.weight = weight
        self.height = height
        self.bmi = bmi
        self.mcurrentLifestyle = currentLifestyle(rawValue: mcurrentLifestyle)
        self.mdesiredLifestyle = desiredLifestyle(rawValue: mdesiredLifestyle)!
        self.distanceGoal = distanceGoal
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "uid":uid,
            "email":email,
            "name":name,
            "age":age ?? 0,
            "sex":sex ?? "unknown",
            "blood-type":bloodType ?? "unknown",
            "weight":weight ?? 0,
            "height":height ?? 0,
            "bmi":bmi ?? 0,
            "current-lifestyle":mcurrentLifestyle.description,
            "desired-lifestyle":mdesiredLifestyle.description,
            "distance-goal":distanceGoal ?? 0
        ]
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        email = snapshotValue["email"] as! String
        name = snapshotValue["name"] as! String
        age = snapshotValue["age"] as? Int
        sex = snapshotValue["sex"] as? String
        bloodType = snapshotValue["blood-type"] as? String
        weight = snapshotValue["weight"] as? Double
        height = snapshotValue["height"] as? Double
        bmi = snapshotValue["bmi"] as? Double
        mcurrentLifestyle = currentLifestyle(rawValue: snapshotValue["current-lifestyle"] as! String)
        mdesiredLifestyle = desiredLifestyle(rawValue: snapshotValue["desired-lifestyle"] as! String)!
        distanceGoal = snapshotValue["distance-goal"] as? Double
        ref = snapshot.ref;
    }
    
}
