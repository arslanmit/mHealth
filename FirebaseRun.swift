//
//  FirebaseRun.swift
//  mHealth
//
//  Created by Loaner on 3/22/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import CoreData
import CoreLocation

class FirebaseRun{
    
     var duration: NSNumber
     var distance: NSNumber
     var climb: NSNumber
     var descent: NSNumber
     var timestamp: NSString
    var latitudes: NSArray
    var longitudes: NSArray
    let ref: FIRDatabaseReference?
    
    init(duration: NSNumber, distance: NSNumber, climb: NSNumber, descent: NSNumber, timestamp: Date, latitudes: NSArray, longitudes: NSArray) {
        self.duration = duration
        self.distance = distance
        self.climb = climb
        self.descent = descent
        self.timestamp = timestamp.description as NSString
        self.latitudes = latitudes
        self.longitudes = longitudes
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        duration = snapshotValue["duration"] as! NSNumber
        distance = snapshotValue["distance"] as! NSNumber
        climb = snapshotValue["climb"] as! NSNumber
        descent = snapshotValue["descent"] as! NSNumber
        timestamp = snapshotValue["timestamp"] as! NSString
        latitudes = snapshotValue["latitudes"] as! NSArray
        longitudes = snapshotValue["longitudes"] as! NSArray
        ref = snapshot.ref
    }
    
    init(run: Run, savedLocations: [Location]) {
        duration = run.duration
        distance = run.distance
        climb = run.climb
        descent = run.descent
        timestamp = run.timestamp.description as NSString
        //lats and longs
        latitudes = NSArray(array: Util.getLatArray(locs: savedLocations))
        longitudes = NSArray(array: Util.getLongArray(locs: savedLocations))
        ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "duration":duration,
            "distance":distance,
            "climb":climb,
            "descent":descent,
            "timestamp":timestamp,
            "latitudes":latitudes,
            "longitudes":longitudes
        ]
    }
    
    func toString(){
        print(duration)
        print(distance)
        print(climb)
        print(descent)
        print(timestamp)
    }
}
