//
//  SideMenuViewController.swift
//  PantryFi
//
//  Created by RAZA on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData

class SideMenuViewController: UIViewController {

    @IBOutlet var profileName: UILabel!
    var users = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        let firstName = users[0].value(forKey: "firstName") as! String?
        let lastName = users[0].value(forKey: "lastName") as! String?
        profileName.text = "\(firstName!) \(lastName!)"
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
        } else {
            print("Could not fetch")
        }
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
