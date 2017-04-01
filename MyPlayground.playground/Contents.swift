//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

var myString = "hello.com/.org|||.mx"


let remove: [String] = [".com",".org",".mx"]

for removable in remove{
    myString = myString.replacingOccurrences(of: removable, with: "")
}

print(myString)