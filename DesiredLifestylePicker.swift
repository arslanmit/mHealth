//
//  DesiredLifestylePicker.swift
//  mHealth
//
//  Created by Loaner on 4/17/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

class DesiredLifestylePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let picks = ["Little Fit", "Fit", "Very Fit"]
    var selectedOption: String = ""
    
    var textField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedOption = picks.first!
        textField.text = selectedOption
        delegate = self
        dataSource = self
        textField.inputView = self
    }
    
    func setSelectedOption(index: Int){
        selectedOption = picks[index]
    }
    
    //MARK: TEXTFIELD FUNCTIONS
    func textFieldDidBeginEditing(textField: UITextField!){
        self.textField = textField
    }
    
    //MARK: ALERTVIEW FUNCTION
    
    func userFirebaseActionSheet(_ sender: SettingsViewController){
        let title = "Desired LifeStyle"
        let message = " \n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 30, y: 15, width: 200, height: 160); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: DesiredLifestylePicker = DesiredLifestylePicker(frame: pickerFrame);
        picker.awakeFromNib()
        alert.view.addSubview(picker);
        
        
        let saveAction = UIAlertAction(title: "Save Style?", style: .default){
            (action: UIAlertAction) in
            
            let id: String = Util.removePeriod(s: (sender.user?.email)!)
            sender.rootRef.child("users//\(id)/User-Data/desired-lifestyle").setValue(picker.selectedOption)
            
        }
        let cancelAction = UIAlertAction(title:"Cancel",  style: .cancel){
            (action:UIAlertAction) in
            return
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        sender.present(alert, animated: true, completion: nil);
    }
    
    
    //MARK: PICKER FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setSelectedOption(index: row)
        textField.text = selectedOption
    }
}
