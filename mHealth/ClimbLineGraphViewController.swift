//
//  ClimbLineGraphViewController.swift
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

class ClimbLineGraphViewController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {

    @IBOutlet weak var lineChart: JBLineChartView!
    @IBOutlet weak var informationLabel: UILabel!
    
    //MARK: Firebase
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    //MARK: Array of Runs
    var runs = [FirebaseRun]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        
        // line chart setup
        lineChart.backgroundColor = UIColor.darkGray
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
        
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: lineChart.frame.width, height: 50))
        header.textColor = UIColor.white
        header.font = UIFont.systemFont(ofSize: 24)
        header.text = "Run: Climb Line Graph"
        header.textAlignment = NSTextAlignment.center
        
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
        let climb = runs[Int(horizontalIndex)].climb
        return CGFloat(climb)
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
        // let distance = Double(String(format: "%.02f", runs[Int(horizontalIndex)].distance))
        let data = String((runs[Int(horizontalIndex)].climb).rounded())
        let date = Util.LineGraphDate(from: runs[Int(horizontalIndex)].timestamp)
        let key = date
        informationLabel.text = "Run on \(key): \(data) m climbed"
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        informationLabel.text = ""
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        return UIColor.clear
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
            self.runs = currentRuns;
            print("LOAD")
            self.lineChart.reloadData()
        })
        print("POST REF LOAD")
    }

}