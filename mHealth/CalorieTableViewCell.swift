//
//  CalorieTableViewCell.swift
//  mHealth
//
//  Created by Loaner on 3/27/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
