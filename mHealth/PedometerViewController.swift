//
//  PedometerViewController.swift
//  mHealth
//
//  Created by Loaner on 3/15/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class PedometerViewController: UIViewController{
    
    @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    var days : [String] = []
    var stepsTaken: [Int] = []
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        var cal = NSCalendar.current
        //let unitFlags: Set<Calendar.Component> = [.year, .month, .day]
        //var comps = cal.components(NSCalendar.Unit.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit, fromDate: NSDate())
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: NSDate() as Date )
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)!
        
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data: CMMotionActivity?) -> Void in
                DispatchQueue.main.async{
                    if(data?.stationary == true){
                        self.activityState.text = "Stationary"
                    } else if (data?.walking == true){
                        self.activityState.text = "Walking"
                    } else if (data?.running == true){
                        self.activityState.text = "Running"
                    } else if (data?.automotive == true){
                        self.activityState.text = "Automotive"
                    }
                }
                
            })
            
        }
        
 
        if(CMPedometer.isStepCountingAvailable()){
            
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerData(from: NSDate() as Date, to: NSDate() as Date, withHandler: { (data: CMPedometerData?, error) in
                print(data!)
                DispatchQueue.main.async{
                    if(error == nil){
                        let n: Int = Int((data?.numberOfSteps)!)
                        let s: String = self.editString(s: String(describing: data?.numberOfSteps))
                        self.steps.text = "\(s)"
                    }
                }
            })
            
            self.pedoMeter.startUpdates(from: midnightOfToday, withHandler: { (data: CMPedometerData?, error) in
                DispatchQueue.main.async{
                    if(error == nil){
                        let n: Int = Int((data?.numberOfSteps)!)
                        let s: String = self.editString(s: String(describing: data?.numberOfSteps))
                        self.steps.text = "\(s)"
                    }
                }
            })
        }
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
    }
    
    func editString(s: String) -> String{
        let o = s
        let o2 = o.replacingOccurrences(of: "Optional(", with: "")
        let mut = o2.replacingOccurrences(of: ")", with: "")
        
        return mut
    }
}
