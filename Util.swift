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
        clean = clean.replacingOccurrences(of: ".org", with: "")
        return clean
    }
    
    class func removeOptional(s: String) -> String{
        let o = s
        let o2 = o.replacingOccurrences(of: "Optional(", with: "")
        let mut = o2.replacingOccurrences(of: ")", with: "")
        
        return mut
    }
}
