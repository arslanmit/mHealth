//
//  RunsTableViewCell.swift
//  mHealth
//
//  Created by Loaner on 3/24/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class RunsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
