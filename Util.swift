//
//  Util.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

class Util{
   class func removePeriod(s: String) -> String{
        let myString = s
        var clean: String
        clean = myString.replacingOccurrences(of: ".com", with: "")
        clean = myString.replacingOccurrences(of: ".org", with: "")
        return clean
    }
}
