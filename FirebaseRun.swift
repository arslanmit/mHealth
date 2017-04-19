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
     var timestamp: String
    var latitudes: [Double]
    var longitudes: [Double]
    var timestamps: [String]
    
    let caloriesBurnt: Double
    
    let ref: FIRDatabaseReference?
    
    init(duration: NSNumber, distance: NSNumber, climb: NSNumber, descent: NSNumber, caloriesBurnt: NSNumber, timestamp: String, latitudes: NSArray, longitudes: NSArray, timestamps: [String]) {
        self.duration = Double(duration)
        self.distance = Double(distance)
        self.climb = Double(climb)
        self.descent = Double(descent)
        self.caloriesBurnt = Double(caloriesBurnt)
        self.timestamp = timestamp
        self.latitudes = latitudes as! [Double]
        self.longitudes = longitudes as! [Double]
        self.timestamps = timestamps
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        duration = snapshotValue["duration"] as! Double
        distance = snapshotValue["distance"] as! Double
        climb = snapshotValue["climb"] as! Double
        descent = snapshotValue["descent"] as! Double
        caloriesBurnt = snapshotValue["calories-burnt"] as! Double
        timestamp = snapshotValue["timestamp"] as! String
        latitudes = snapshotValue["latitudes"] as! [Double]
        longitudes = snapshotValue["longitudes"] as! [Double]
        timestamps = snapshotValue["timestamps"] as! [String]
        ref = snapshot.ref
    }
    
    init(run: Run, savedLocations: [Location]) {
        duration = Double(run.duration)
        distance = Double(run.distance)
        climb = Double(run.climb)
        descent = Double(run.descent)
        caloriesBurnt = Double(run.caloriesBurnt)
        timestamp = Util.DateString(from: (savedLocations.last?.timestamp)!) as String
        //lats and longs
        latitudes = Util.getLatArray(locs: savedLocations)
        longitudes = Util.getLongArray(locs: savedLocations) //NSArray(array: Util.getLongArray(locs: savedLocations))
        timestamps = Util.getTimestampArray(locs: savedLocations)
        ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "duration":duration,
            "distance":distance,
            "climb":climb,
            "descent":descent,
            "calories-burnt":caloriesBurnt,
            "timestamp":timestamp,
            "latitudes":latitudes,
            "longitudes":longitudes,
            "timestamps":timestamps
        ]
    }
    
    func toString(){
        print(duration)
        print(distance)
        print(climb)
        print(descent)
        print(timestamp)
        print(caloriesBurnt)
        dump(latitudes)
        dump(longitudes)
        dump(timestamps)
    }
}
