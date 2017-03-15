//
//  mHealthUser.swift
//  mHealth
//
//  Created by Loaner on 3/15/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase

struct mHealthUser{
    
    let uid: String
    let email: String
    let sex: String
    let bloodType: String
    let weight: String
    let height: String
    let bmi: String

    init(uid: String, email: String, sex: String, bloodType: String, weight: String, height: String, bmi: String) {
        self.uid = uid
        self.email = email
        self.sex = sex
        self.bloodType = bloodType
        self.weight = weight
        self.height = height
        self.bmi = bmi
    }
    
    func toAnyObject() -> Any {
        return [
            "color":uid,
            "email":email,
            "sex":sex,
            "blood-type":bloodType,
            "weight":weight,
            "height":height,
            "bmi":bmi
        ]
    }
    /*
    init(snapshot: FIRDataSnapshot) {
    /*    let snapshotValue = snapshot.value as! [String: AnyObject]
        color = snapshotValue["color"] as! String
        friend = snapshotValue["friend"] as! String
        ref = snapshot.ref */
    } */
    
}
