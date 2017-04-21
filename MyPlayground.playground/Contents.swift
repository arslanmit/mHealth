//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

/*
print("mHealth")


let fit: Bool = true


print("Fitness Level = Fit... \(fit)")


print("good job!")


*/
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

extension String{
    
    public func dropFirst(){
        
    }
    
}

let pi: Double = Double.pi - 3

let h: String = "hello"


String(h.characters.dropFirst())




