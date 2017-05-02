//
//  RecipeResultTableViewCell.swift
//  PantryFi
//
//  Created by david ares on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class RecipeResultTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
