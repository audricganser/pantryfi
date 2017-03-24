//
//  ViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/14/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
     var users = [NSManagedObject]()

    override func viewDidLoad() {
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
        
        self.errorLabel.text = ""
        //loads users from core data
        loadData()

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
        
        if (email.text?.isEmpty)! || (password.text?.isEmpty)! {
            self.errorLabel.text = "fields are empty"
        }
        else if users.count == 0 {
            self.errorLabel.text = "Create New Account"
        }
        else {
            let e = email.text
            let p = password.text
            for i in 0...users.count-1 {
                let user = users[i]
                let tmpEmail = user.value(forKey: "email") as? String
                if tmpEmail! == e! {
                    let tmpPass = user.value(forKey: "password") as? String
                    if tmpPass! == p! {
                        // user matches
                        print("logged in")
                        let storyBoard1:UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                        let nextViewController = storyBoard1.instantiateViewController(withIdentifier: "Navigation")
                        self.present(nextViewController, animated:true, completion:nil)

                    
                    }
                }
                else {
                    self.errorLabel.text = "wrong email and/or password"
                }
            }
            
        }

    }
    
    fileprivate func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"User")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            users = results
            print("got the data")
        } else {
            print("Could not fetch")
        }
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

