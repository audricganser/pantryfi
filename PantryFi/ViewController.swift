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
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
     var users = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads users from core data
        loadData()

        // Do any additional setup after loading the view, typically from a nib.
        //changed content for initial commit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if (email.text?.isEmpty)! || (password.text?.isEmpty)! {
            print("fields are empty")
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
                    }
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



}

