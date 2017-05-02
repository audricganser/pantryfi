//
//  ViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/14/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
     var users = [NSManagedObject]()

    override func viewDidLoad() {
        
        if FIRAuth.auth()?.currentUser != nil {
            loginSegue()
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        email.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                         attributes: [NSForegroundColorAttributeName: UIColor.black])
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        
        if FIRAuth.auth()?.currentUser != nil
        {
            //user is signed in
            self.loginSegue()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        //changed content for initial commit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        guard let email = email.text, let password = password.text
            
        else
        {
            print("Missing elements")
            return
        }
        if (email.isEmpty == true || password.isEmpty == true)
        {
            let alertController = UIAlertController(title: "Alert", message: "Please enter username and password", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(oKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            
            if error != nil {
                print(error!)
                
                let alertController = UIAlertController(title: "Login Failed", message: "Incorrect Username or Password", preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(oKAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // successfully logged in the user
            print("user logged in successfully")
            self.loginSegue()
            
        })
    }
    
    @IBAction func facebookButton(_ sender: Any)
    {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                FIRAuth.auth()?.signIn(with: credential) { (user,error) in
                    
                    if let error = error {
                        print("Error \(error))")
                        return
                    }
                    print("User logged into Firebase")
                    let uid = user!.uid
                    
                    if user?.uid != nil
                    {
                        guard let email = user?.email, let name = user?.displayName
                        else
                        {
                            return
                        }
                        
                        let uid = user!.uid
                        let values: [String: Any] = ["name":name]
                        var ref: FIRDatabaseReference!
                        ref = FIRDatabase.database().reference(fromURL: "https://pantryfi-2e385.firebaseio.com/")
                        ref.child("users").child(uid).updateChildValues(values)
                        self.loginSegue()
                        
                    }
                    else
                    {
                        self.loginSegue()
                    }
                }
            }
        }
    }
    
    func loginSegue ()
    {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let nextViewController = storyBoard1.instantiateViewController(withIdentifier: "TabController")
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("hit")
        let backItem = UIBarButtonItem()
        backItem.title = "Login"
        navigationItem.backBarButtonItem = backItem
        
    }
    
    // Keyboard functions
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

