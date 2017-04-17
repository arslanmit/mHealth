//
//  UserHKData.swift
//  mHealth
//
//  Created by Loaner on 3/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

class test: UIViewController{

func showPickerInActionSheet() {
    let title = ""
    let message = "\n\n\n\n\n\n\n\n\n\n";
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
    alert.isModalInPopover = true;
    
    
    //Create a frame (placeholder/wrapper) for the picker and then create the picker
    let pickerFrame: CGRect = CGRect(x: 17, y: 52, width: 330, height: 200); // CGRectMake(left), top, width, height) - left and top are like margins
    //let picker: DesiredLifestylePicker = DesiredLifestylePicker(frame: pickerFrame);
    let picker = UIPickerView(frame: pickerFrame)
    picker.awakeFromNib()
    alert.view.addSubview(picker);
    
    //Create the toolbar view - the view witch will hold our 2 buttons
    let toolFrame = CGRect(x: 17, y: 5, width: 270, height: 45);
    let toolView: UIView = UIView(frame: toolFrame);
    
    //add buttons to the view
    let buttonCancelFrame: CGRect = CGRect(x: 0, y: 7, width: 100, height: 30); //size & position of the button as placed on the toolView
    
    //Create the cancel button & set its title
    let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
    buttonCancel.setTitle("Cancel", for: UIControlState.normal);
    buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
    toolView.addSubview(buttonCancel); //add it to the toolView
    
    //Add the target - target, function to call, the event witch will trigger the function call
    buttonCancel.addTarget(self, action: Selector(("cancelSelection:")), for: UIControlEvents.touchDown);
    
    
    //add buttons to the view
    let buttonOkFrame: CGRect = CGRect(x: 170, y: 7, width: 100, height: 30); //size & position of the button as placed on the toolView
    
    //Create the Select button & set the title
    let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
    buttonOk.setTitle("Select", for: UIControlState.normal);
    buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
    toolView.addSubview(buttonOk); //add to the subview
    //add the toolbar to the alert controller
    alert.view.addSubview(toolView);
    
    self.present(alert, animated: true, completion: nil);
}
    override func viewDidLoad() {
        showPickerInActionSheet()
        print("helo")
    }

}