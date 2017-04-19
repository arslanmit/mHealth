//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var doubleValue:Double? {
        return Double(self)
    }
    var integerValue:Int? {
        return Int(self)
    }
}



let s = "hello"

let sn = "1.23"

sn.doubleValue
s.doubleValue

let a = Array(0...100)

a.map{
    Double($0)/10
}
