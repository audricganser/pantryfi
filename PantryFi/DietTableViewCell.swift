//
//  DietTableViewCell.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/17/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class DietTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
