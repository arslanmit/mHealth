//
//  favorite.swift
//  mHealth
//
//  Created by Loaner on 3/2/17.
//  Copyright © 2017 JTMax. All rights reserved.
//
import Foundation
import Firebase

struct favorite {
    
    let color: String
    let friend: String
    let ref: FIRDatabaseReference?
    
    init(color: String, friend: String) {
        self.color = color
        self.friend = friend
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        color = snapshotValue["color"] as! String
        friend = snapshotValue["friend"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "color":color,
            "friend":friend
        ]
    }
    
}
