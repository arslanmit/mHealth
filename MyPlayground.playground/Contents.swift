//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

let dateFormatter = DateFormatter()
let date = Date()

dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
dateFormatter.string(from: date)

dateFormatter.dateFormat = "MMMM dd, yyyy"
print(dateFormatter.string(from: date))
