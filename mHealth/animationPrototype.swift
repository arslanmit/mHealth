//
//  animationPrototype.swift
//  mHealth
//
//  Created by Loaner on 4/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView


class animationPrototypeViewController: UIViewController{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var exampleContainerView: UIView!
    @IBOutlet weak var titleLabels: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpBackground()
        startAnimation(self)
    }
    var gradient = CAGradientLayer()
    
    func setUpBackground() {
        
        if ((self.gradient) != nil) {
            self.gradient.removeFromSuperlayer()
            //self.gradient = nil
        }
        
        let tempLayer: CAGradientLayer = CAGradientLayer()
        tempLayer.frame = self.view.bounds
        tempLayer.colors = [UIColor(netHex: 0x53cf84).cgColor, UIColor(netHex: 0x53cf84).cgColor, UIColor(netHex: 0x2aa581).cgColor, UIColor(netHex: 0x1b9680).cgColor]
        tempLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.5), NSNumber(value: 0.8), NSNumber(value: 1.0)]
        tempLayer.startPoint = CGPoint(x: 0, y: 0)
        tempLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.gradient = tempLayer
        self.backgroundView.layer.insertSublayer(self.gradient, at: 1)
        self.exampleContainerView.isHidden = true
    }
    @IBAction func startAnimation(_ sender: Any) {
        let myView:BAFluidView = BAFluidView(frame: self.view.frame, startElevation: 0.5)
        
        myView.strokeColor = UIColor.white
        myView.fillColor = UIColor(netHex: 0x2e353d)
        myView.keepStationary()
        myView.startAnimation()
        titleLabels.textColor = UIColor.white
        self.exampleContainerView.isHidden = false
        myView.startAnimation()
        
        self.view.insertSubview(myView, aboveSubview: self.backgroundView)
        
        UIView.animate(withDuration: 0.5, animations: {
            myView.alpha=1.0
        }, completion: { _ in
            self.titleLabels.text = "Progress..."
            self.titleLabels.isHidden = false
            self.exampleContainerView.removeFromSuperview()
            self.exampleContainerView = myView
        })
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
