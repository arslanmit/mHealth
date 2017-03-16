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
    case ModeratelyFit = "Moderately Fit"
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    var description: String {
        return self.rawValue
    }
}

enum desiredLifestyle : String {
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
    let sex: String?
    let bloodType: String?
    let weight: Double?
    let height: Double?
    let bmi: Double?
    let mcurrentLifestyle: currentLifestyle
    let mdesiredLifestyle: desiredLifestyle
    
    
    let ref: FIRDatabaseReference?

    init(uid: String,
         email: String,
         name: String = " ",
         sex: String? = nil,
         bloodType: String? = nil,
         weight: Double? = nil,
         height: Double? = nil,
         bmi: Double? = nil,
         mcurrentLifestyle: String,mdesiredLifestyle: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.sex = sex
        self.bloodType = bloodType
        self.weight = weight
        self.height = height
        self.bmi = bmi
        self.mcurrentLifestyle = currentLifestyle(rawValue: mcurrentLifestyle)!
        self.mdesiredLifestyle = desiredLifestyle(rawValue: mdesiredLifestyle)!
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "uid":uid,
            "email":email,
            "name":name,
            "sex":sex ?? "unknown",
            "blood-type":bloodType ?? "unknown",
            "weight":weight ?? 0,
            "height":height ?? 0,
            "bmi":bmi ?? 0,
            "current-lifestyle":mcurrentLifestyle.description,
            "desired-lifestyle":mdesiredLifestyle.description
        ]
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        email = snapshotValue["email"] as! String
        name = snapshotValue["name"] as! String
        sex = snapshotValue["sex"] as? String
        bloodType = snapshotValue["blood-type"] as? String
        weight = snapshotValue["weight"] as? Double
        height = snapshotValue["height"] as? Double
        bmi = snapshotValue["bmi"] as? Double
        mcurrentLifestyle = currentLifestyle(rawValue: snapshotValue["current-lifestyle"] as! String)!
        mdesiredLifestyle = desiredLifestyle(rawValue: snapshotValue["desired-lifestyle"] as! String)!
        ref = snapshot.ref;
    }
    
}
