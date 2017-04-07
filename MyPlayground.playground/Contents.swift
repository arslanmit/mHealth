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

dateFormatter.dateFormat = "MM/d @h:mma"
dateFormatter.string(from: date)


let duration = String(format: "%.02f", 3.32323242)
