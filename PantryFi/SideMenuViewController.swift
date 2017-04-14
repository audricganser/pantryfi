//
//  SideMenuViewController.swift
//  PantryFi
//
//  Created by RAZA on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class SideMenuViewController: UIViewController {

    @IBOutlet var profileName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let firstName = dictionary["firstName"] as? String
                    let lastName = dictionary["lastName"] as? String
                    
                    self.profileName.text = "\(firstName!) \(lastName!)"

                }
            }, withCancel:nil)}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
