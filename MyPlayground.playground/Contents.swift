//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

class UserHKData{
    var age: Int = 0
    var sex: String = "unknown"
    var bloodType: String = "unknown"
    var weight: Double = 0
    var height: Double = 0
    var bmi: Double = 0
}



let test:NSNumber = 10.02

let t2: Double = Double(test)


var tada: [Double] = [2,31.1,42.5]
var longitudes: NSArray = (array: tada) as NSArray


tada.first
tada.last


let new: [Double] = longitudes as! [Double]

tada.append(3.21)

tada
///////



let timestamp = "2017-03-23 22:39:22"

let myDate = "2016-06-20T13:01:46.457+02:00"

let dateFormatter = DateFormatter()

//dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
var date = dateFormatter.date(from:timestamp)!
dateFormatter.dateFormat = "hh:MMa|MM/d (EEE)"
var dateString = dateFormatter.string(from:date)




dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
 var ate = dateFormatter.date(from:timestamp)!





dateFormatter.dateFormat = "EEE| MMM d, yyyy @HH:MMa"
 dateString = dateFormatter.string(from:date)



let this: Double = ate.timeIntervalSince(date)

ate.timeIntervalSince(date)
































