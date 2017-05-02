//
//  RecipeIngredientsTableViewCell.swift
//  PantryFi
//
//  Created by david ares on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class RecipeIngredientsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
