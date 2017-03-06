//
//  User.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase

enum lifeStyle: String{
    case moderatleyFit = "Moderately Fit"
    case fit = "Average Fit"
    case veryFit = "Very Fit"
}

struct User {
    
    let uid: String
    let email: String
    /*
    let name: String
    let currentLifeStyle: lifeStyle
    let desiredLifeStyle: lifeStyle */
    
    
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
