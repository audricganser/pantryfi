//
//  ProfileViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/17/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        emailLabel.text = ""
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            
            let email = user.email
            
            nameLabel.text = ""
            emailLabel.text = email
            // ...
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func backHome(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenu")
        self.present(nextViewController, animated:true, completion:nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
