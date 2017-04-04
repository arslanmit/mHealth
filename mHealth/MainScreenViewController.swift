//
//  MainScreenViewController.swift
//  mHealth
//
//  Created by Loaner on 4/3/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

class MainScreenViewController : UIViewController{
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad(){
        self.mainView.layer.cornerRadius = 5.0
    }
}
