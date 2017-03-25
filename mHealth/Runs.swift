//
//  Runs.swift
//  mHealth
//
//  Created by Loaner on 3/24/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class Runs{
    
    var date: String
    var time: String
    
    init?(date: String, time: String){
        guard !date.isEmpty else {
            return nil
        }
        
        guard !time.isEmpty else {
            return nil
        }
        
        self.date = date
        self.time = time
    }
    
}
