import UIKit
import Foundation
import Firebase


enum currentLifestyle : String {
    case ModeratelyFit = "Moderately Fit"
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    var description: String {
        return self.rawValue
    }
}

enum desiredLifestyle : String {
    case Fit = "Fit"
    case VeryFit = "Very Fit"
    
    var description: String {
        return self.rawValue
    }
}


let t: currentLifestyle = .ModeratelyFit

print(t)
///these are the string values
print(t.rawValue)
print(t.description)

let x: currentLifestyle = currentLifestyle(rawValue: t.rawValue)!

