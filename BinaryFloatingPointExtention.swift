//
//  BinaryFloatingPointExtention.swift
//  mHealth
//
//  Created by Loaner on 4/20/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
    
    var zerolessStringValue: String{
        return String(describing: self).replacingOccurrences(of: "0", with: "")
    }
    
    public func rounded(toPlaces places: Int) -> Self {
        guard places >= 0 else { return self }
        let divisor = Self((0..<places).reduce(1.0) { $0.0 * 10.0 })
        return (self * divisor).rounded() / divisor
    }
    
}
