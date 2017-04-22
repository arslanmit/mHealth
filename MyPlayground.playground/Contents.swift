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
enum currentLifestyle : String {
    case NotFit = "Not Fit"
    case LittleFit = "Little Fit"
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    init(rawValue: String) {
        switch rawValue {
        case "Not Fit": self = .NotFit
        case "Little Fit": self = .LittleFit
        case "Fit": self = .Fit
        case "Very Fit": self = .VeryFit
        default: self = .NotFit
        }
    }
    
    var emoji: String{
        switch(self){
        case .NotFit:
            return "💩"
        case .LittleFit:
            return "🤕"
        case .Fit:
            return "😎"
        case .VeryFit:
            return "😈"
        default:
            break
        }
    }
}

let x: currentLifestyle = currentLifestyle(rawValue: "hello")


