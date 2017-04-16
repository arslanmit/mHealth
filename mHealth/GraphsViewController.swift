//
//  GraphsViewController.swift
//  mHealth
//
//  Created by Loaner on 4/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var distanceContainer: UIView!
    @IBOutlet weak var timeContainer: UIView!
    @IBOutlet weak var climbContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true 
        self.distanceContainer.alpha = 1
        self.timeContainer.alpha = 0
        self.climbContainer.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.distanceContainer.alpha = 1
                self.timeContainer.alpha = 0
                self.climbContainer.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.distanceContainer.alpha = 0
                self.timeContainer.alpha = 1
                self.climbContainer.alpha = 0
            })
        } else{
            UIView.animate(withDuration: 0.5, animations: {
            self.distanceContainer.alpha = 0
            self.timeContainer.alpha = 0
            self.climbContainer.alpha = 1
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
