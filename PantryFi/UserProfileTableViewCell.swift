//
//  UserProfileTableViewCell.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/28/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.text = ""
        
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let name = dictionary["name"] as? String
                    self.nameLabel.text = "\(name!)"
                }
            }, withCancel: nil)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
