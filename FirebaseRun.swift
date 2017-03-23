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
    
     var duration: Double
     var distance: Double
     var climb: Double
     var descent: Double
     var timestamp: NSString
    var latitudes: [Double]
    var longitudes: [Double]
    let ref: FIRDatabaseReference?
    
    init(duration: NSNumber, distance: NSNumber, climb: NSNumber, descent: NSNumber, timestamp: Date, latitudes: NSArray, longitudes: NSArray) {
        self.duration = Double(duration)
        self.distance = Double(distance)
        self.climb = Double(climb)
        self.descent = Double(descent)
        self.timestamp = timestamp.description as NSString
        self.latitudes = latitudes as! [Double]
        self.longitudes = longitudes as! [Double]
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        duration = snapshotValue["duration"] as! Double
        distance = snapshotValue["distance"] as! Double
        climb = snapshotValue["climb"] as! Double
        descent = snapshotValue["descent"] as! Double
        timestamp = snapshotValue["timestamp"] as! NSString
        latitudes = snapshotValue["latitudes"] as! [Double]
        longitudes = snapshotValue["longitudes"] as! [Double]
        ref = snapshot.ref
    }
    
    init(run: Run, savedLocations: [Location]) {
        duration = Double(run.duration)
        distance = Double(run.distance)
        climb = Double(run.climb)
        descent = Double(run.descent)
        timestamp = run.timestamp.description as NSString
        //lats and longs
        latitudes = Util.getLatArray(locs: savedLocations)
        longitudes = Util.getLatArray(locs: savedLocations) //NSArray(array: Util.getLongArray(locs: savedLocations))
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
        dump(latitudes)
        dump(longitudes)
    }
}
