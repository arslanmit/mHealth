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
            myTimes.append(Util.DateString(from: locs.timestamp))
        }
        return myTimes
    }
    
    class func DateString(from date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        return dateFormatter.string(from: date)
    }

//MARK: FIREBASE TITLE
    class func FirebaseTitle(from date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE| MMM-d-yy @hh:mma"
        return dateFormatter.string(from: date)
    }
    
    class func FirebaseTitle(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let thisDate = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "EEE| MMM-d-yy @hh:mma"
        return dateFormatter.string(from: thisDate)
    }

//MARK: DATE
    class func LineGraphDate(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let thisDate = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "MM/d @h:mma"
        return dateFormatter.string(from: thisDate)
    }
    
    class func PastRunsDate(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func LineGraphDateHeader(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
//MARK: TIME
    class func PastRunsTime(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: date)
    }
    
//MARK: PIN FORMATS
    class func PinFormat(from date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma|MM/d (EEE)"
        return dateFormatter.string(from: date)
    }
    
    class func PinFormat(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        
        dateFormatter.dateFormat = "hh:mma|MM/d (EEE)"
        return dateFormatter.string(from: date)
    }
//MARK: CREATE DATE FROM STRING
    class func Date(from date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: date)!
        return date
    }
//MARK: INTERVALS
    class func timeInterval(from date1: String, to date2: String) ->Double{
        return self.Date(from: date2).timeIntervalSince(Util.Date(from: date1));
    }
//MARK: UNIT CONVERSIONS
    class func metersToMilesString(distanceQuantity: HKQuantity) -> String{
        let dist: Double = (Double(distanceQuantity.description.replacingOccurrences(of: " m", with: "")))!*0.00062137
        let distString: String = String(format: "%.2f", ceil(dist*100)/100)
        return distString;
    }
    
    class func getMiles(from meters: Double) -> Double{
        let dist: Double = meters*0.00062137
        let distString: String = String(format: "%.2f", ceil(dist*100)/100)
        return Double(distString)!
    }
    
    class func kmphToMphString(kmph: Double) -> String{
        let paceDouble: Double = (((kmph*3.6*10).rounded()/10)*0.62137)
        let paceString: String = String(format: "%.2f", ceil(paceDouble*100)/100)
        return paceString
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
}
