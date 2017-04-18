//
//  CurrentLifestylePicker.swift
//  mHealth
//
//  Created by Loaner on 4/17/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

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
