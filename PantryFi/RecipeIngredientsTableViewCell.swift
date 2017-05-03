//
//  RecipeIngredientsTableViewCell.swift
//  PantryFi
//
//  Created by david ares on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RecipeIngredientsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var ingredient:Ingredient = Ingredient.init()
    
    var ref = FIRDatabase.database().reference(withPath: "shoppingList")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func addToShoppingList(_ sender: Any) {
//        print("I was clicked")
//        if let user = FIRAuth.auth()?.currentUser
//        {
//            let uid = user.uid
//            let shoppingItemRef = self.ref.child(uid).child(self.ingredient.name.lowercased())
//                            
//            shoppingItemRef.setValue(self.ingredient.toAnyObject())
//                            
//            let alert = UIAlertController(title: "Success", message:"The item was added to your shopping cart", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in self.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion:nil)
//            }
//    }

}
