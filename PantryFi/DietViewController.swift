//
//  DietViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/17/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DietViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    var items = [Diet]()
    var ref = FIRDatabase.database().reference(withPath: "dietList")

    @IBOutlet weak var tableView: UITableView!
    
    var diets:[Diet] = [Diet.init(diet: "Vegan", dietSwitch: false), Diet.init(diet: "Vegetarian", dietSwitch: false), Diet.init(diet: "Gluten Free", dietSwitch: false), Diet.init(diet: "Ketogenic", dietSwitch: false), Diet.init(diet: "Whole 30", dietSwitch: false), Diet.init(diet: "Paleo", dietSwitch: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            
            ref.child(uid).queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
                var newItems: [Diet] = []
                
                for item in snapshot.children {
                    let dietItem = Diet(snapshot: item as! FIRDataSnapshot)
                    newItems.append(dietItem)
                }
                self.items = self.diets
                
                self.tableView.reloadData()
            })
        }
        
        if self.items.count == 0 {
            self.items = self.diets
            print("items here \(self.items)")
            for d in self.diets {
                self.saveDiet(diet: d)
            }
        }

        
        tableView.isScrollEnabled = false;
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("diets count \(diets.count)")
        return self.diets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dietCell", for: indexPath) as!
        DietTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        print("items \(self.items)")
        print("index path row \(indexPath.row)")
        cell.dietLabel.text = self.items[indexPath.row].diet
        cell.dietCellSwitch.tag = indexPath.row
        
        return cell
    }
    
    func saveDiet (diet:Diet) {
        // save  into data base
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            let diet = Diet(diet:diet.diet, dietSwitch:diet.dietSwitch)
        
            let dietItemRef = self.ref.child(uid).child((title?.lowercased())!)
        
            dietItemRef.setValue(diet.toAnyObject())
        }

        
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        print("switch changed")
        let row = sender.tag
        let diet = items[row]
        diet.dietSwitch = sender.isOn
        saveDiet(diet: diet)
        
        //var switchResult =
//        let title = "placeholder"
//        if self.dietSwitch.isOn {
//            dietSwitch = self.dietSwitch.isOn
//        }
//        if let user = FIRAuth.auth()?.currentUser
//        {
//            let uid = user.uid
//            let diet = Diet(name:title, dietSwitch:amount)
//            
//            let dietItemRef = self.ref.child(uid).child((title?.lowercased())!)
//            
//            dietItemRef.setValue(diet.toAnyObject())
//        }
    }
}
