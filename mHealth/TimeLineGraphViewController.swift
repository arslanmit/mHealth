//
//  TimeLineGraphViewController.swift
//  mHealth
//
//  Created by Loaner on 4/13/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit
import JBChartView
import Firebase
import HealthKit

class TimeLineGraphViewController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    
    @IBOutlet weak var lineChart: JBLineChartView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var header: UILabel!
    
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    //MARK: Array of Runs
    var runs = [FirebaseRun]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.clear
        
        // line chart setup
        lineChart.backgroundColor = UIColor.clear
        lineChart.delegate = self
        lineChart.dataSource = self
        lineChart.minimumValue = 55
        lineChart.maximumValue = 100
        
        lineChart.setState(.collapsed, animated: false)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: lineChart.frame.width, height: 16))
        
        //printviewDidLoad;:  (lineChart.frame.width)")
        
        let footer1 = UILabel(frame: CGRect(x: 0, y: 0, width: lineChart.frame.width/2 - 8, height: 16))
        footer1.textColor = UIColor.white
        footer1.text = "First Run"
        
        let footer2 = UILabel(frame: CGRect(x: lineChart.frame.width/2 - 8, y: 0, width: lineChart.frame.width/2 - 8, height: 16))
        footer2.textColor = UIColor.white
        footer2.text = "Last Run"
        footer2.textAlignment = NSTextAlignment.right
        
        footerView.addSubview(footer1)
        footerView.addSubview(footer2)
        
        lineChart.footerView = footerView
        lineChart.headerView = header
        
        //MARK: FIREBASE start up
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath: "users//\(id)/")
        runRef.observe(.value, with: { snapshot in
            self.load()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(DistanceLineGraphViewController.showChart), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart() {
        lineChart.setState(.collapsed, animated: true)
    }
    
    func showChart() {
        lineChart.setState(.expanded, animated: true)
    }
    
    // MARK: JBlineChartView
    
    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(runs.count)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let time = runs[Int(horizontalIndex)].duration
        return CGFloat(time)
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightGray
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightGray
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt) {
        let (h,m,s) = Util.secondsToHoursMinutesSeconds(seconds: Int(runs[Int(horizontalIndex)].duration))
        header.text = "On \(Util.LineGraphDateHeader(from: runs[Int(horizontalIndex)].timestamp)), "
        informationLabel.text = "You ran \(h) hours and \(m) minutes!"
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        header.text = "Your Runs"
        informationLabel.text = ""
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.darkGray
    }
    
    private func load(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath: "users//\(id)/Runs/")
        runRef.observe(.value, with: { snapshot in
            var currentRuns = [FirebaseRun]()
            for run in snapshot.children{
                let oldRun = FirebaseRun(snapshot: run as! FIRDataSnapshot)
                currentRuns.append(oldRun)
            }
            currentRuns.sort(by: { Util.Date(from: $0.timestamp).compare(Util.Date(from: $1.timestamp)) == ComparisonResult.orderedAscending})
            self.runs = currentRuns;
            self.lineChart.reloadData()
        })
    }
    
    func distanceArray() -> Array<String>{
        var distanceRuns = [String]()
        for dist in runs{
            distanceRuns.append(String(dist.distance))
        }
        return distanceRuns
    }
    
    
    @IBAction func loadDidTouch(_ sender: Any) {
        dump(runs)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
