//
//  SignUpViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/14/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase
import CoreData

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    var users = [NSManagedObject]()

    
    override func viewDidLoad() {
        firstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
        lastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        email.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        confirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        self.navigationItem.title = ""
        self.errorLabel.text = ""
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        
        //check if any fields are empty
        if (firstName.text?.isEmpty)! ||
            (lastName.text?.isEmpty)! ||
            (email.text?.isEmpty)!    ||
            (password.text?.isEmpty)! ||
            (confirmPass.text?.isEmpty)! {
            
            self.errorLabel.text = "Please fill out all fields"
        }
        //check if email is valid
        else if (!isValidEmail(email: email.text!)) {
            self.errorLabel.text = "email is invalid"
        }
        //checks if confirm password and password match
        else if (password.text != confirmPass.text){
                self.errorLabel.text = "your password doesn't match"
        }
        //save the user on core data
        else {
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                
            }
            guard let firstName = firstName.text, let lastName = lastName.text else {
                print("Form is not valid")
                return
            }
            
            let values: [String : Any] = ["firstName": firstName, "lastName": lastName]
            //var ref: FIRDatabaseReference!

            
            //hides keyboard once candidate is saved
            self.view.endEditing(true)
            
            let storyBoard1:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard1.instantiateViewController(withIdentifier: "Login")
            self.present(nextViewController, animated:true, completion:nil)

        }
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        //print("email is \(emailTest.evaluate(with: email))")
        return emailTest.evaluate(with: email)
    }
    
    // Keyboard functions
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
