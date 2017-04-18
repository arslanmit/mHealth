//
//  CustomUIPickers.swift
//  mHealth
//
//  Created by Loaner on 4/17/17.
//  Copyright © 2017 JTMax. All rights reserved.
//
/* USAGE:
 
 >>>> When constructing a textfield to display custom picker... you must do the following...
    let pick = CurrentLifestylePicker()
    pick.textField = textfield
    pick.awakeFromNib()
 
 >>>> If you instansiate via storyboard, this isn't necessary... but then you would have to have it shown on the view all the time i guess.... sry idk
 */
import UIKit
import Foundation


class CurrentLifestylePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let picks = ["Not Fit","Little Fit", "Fit", "Very Fit"]
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 12, y: 15, width: 330, height: 160); // CGRectMake(left), top, width, height) - left and top are like margins
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

class DistanceGoalPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let segments = (whole: (Array(0...100).map{String($0)}), decimal: (Array(0...99).map{String($0)}), ["miles"])
    
    var selectedOption: String = ""
    
    var textField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelected(wholeIndex: 0, decimalIndex: 0)
        delegate = self
        dataSource = self
        textField.inputView = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismiss))
        
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    func dismiss(){
        textField.endEditing(true)
    }
    
    
    
    func setSelected(wholeIndex: Int, decimalIndex: Int){
        let segments = (whole: (Array(0...100).map{String($0)}), decimal: (Array(0...99).map{String($0)}))
        selectedOption = "\(segments.whole[wholeIndex]).\(segments.whole[decimalIndex])"
    }
    
    //MARK: PICKER FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return segments.0.count
        }else if component == 1 {
            return segments.1.count
        }else{
            return segments.2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return segments.0[row]
        }else if component == 1 {
            return ".\(segments.1[row])"
        }else{
            return segments.2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let whole = pickerView.selectedRow(inComponent: 0)
        let decimal = pickerView.selectedRow(inComponent: 1)
        setSelected(wholeIndex: whole, decimalIndex: decimal)
        textField.text = selectedOption
    }
    
   /*/ MARK: action
    func pickerAlertView(_ sender: CreateAccountViewController){
        let title = "Distance Goal"
        let message = " \n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 12, y: 25, width: 330, height: 160); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: DistanceGoalPicker = DistanceGoalPicker(frame: pickerFrame);
        picker.awakeFromNib()
        alert.view.addSubview(picker);
        
        
        let saveAction = UIAlertAction(title: "Save Style?", style: .default){
            (action: UIAlertAction) in
            sender.distanceGoalTextField.text = picker.selectedOption
        }
        let cancelAction = UIAlertAction(title:"Cancel",  style: .cancel){
            (action:UIAlertAction) in
            return
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        sender.present(alert, animated: true, completion: nil);
    }*>>>> can't use this action thing because i'm just putting it to the text field vs saving it to firebase like the first two pickers... simply added to the didSelect configured with the referenced textfield..... sry 4 spagghettio */
}
