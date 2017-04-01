//
//  Util.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import HealthKit
import MapKit
import AudioToolbox
import Firebase

class Util{
    
   class func removePeriod(s: String) -> String{
    var myString = s
    
    let remove: [String] = [".com",".org",".mx"]
    
    for removable in remove{
        myString = myString.replacingOccurrences(of: removable, with: "")
    }
        return myString
    }
    
    class func removeOptional(s: String) -> String{
        let o = s
        let o2 = o.replacingOccurrences(of: "Optional(", with: "")
        let mut = o2.replacingOccurrences(of: ")", with: "")
        
        return mut
    }
    
    class func getLatArray(locs: [Location]) -> [Double]{
        var myLats = [Double]()
        for loc in locs{
            myLats.append(Double(loc.latitude))
        }
        return myLats
    }
    
    class func getLongArray(locs: [Location]) -> [Double]{
        var myLongs = [Double]()
        for loc in locs{
            myLongs.append(Double(loc.longitude))
        }
        return myLongs
    }
    
    class func getTimestampArray(locs: [Location]) -> [String]{
        var myTimes = [String]()
        for locs in locs{
            myTimes.append(Util.myDateFormat(date: locs.timestamp))
        }
        return myTimes
    }
    
    class func myDateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        return dateFormatter.string(from: date)
    }
    
    class func dateFirebaseTitle(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE| MMM-d-yy @hh:mma"
        return dateFormatter.string(from: date)
    }
    
    class func dateToPinString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma|MM/d (EEE)"
        return dateFormatter.string(from: date)
    }
    
    class func stringToDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        return date
    }

    class func timeInterval(from date1: String, to date2: String) ->Double{
        return self.stringToDate(date: date2).timeIntervalSince(Util.stringToDate(date: date1));
    }
    
    class func metersToMilesString(distanceQuantity: HKQuantity) -> String{
        let dist: Double = (Double(distanceQuantity.description.replacingOccurrences(of: " m", with: "")))!*0.00062137
        let distString: String = String(format: "%.2f", ceil(dist*100)/100)
        return distString;
    }
    
    class func kmphToMphString(kmph: Double) -> String{
        let paceDouble: Double = (((kmph*3.6*10).rounded()/10)*0.62137)
        let paceString: String = String(format: "%.2f", ceil(paceDouble*100)/100)
        return paceString
    }
    
    
}
