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
    
    var diets:[Diet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diets = [Diet.init(diet: "Vegan", dietSwitch: false), Diet.init(diet: "Vegetarian", dietSwitch: false), Diet.init(diet: "Gluten Free", dietSwitch: false), Diet.init(diet: "Ketogenic", dietSwitch: false), Diet.init(diet: "Whole 30", dietSwitch: false), Diet.init(diet: "Paleo", dietSwitch: false)]
        
        //print(self.items.count)
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
          
            ref.child(uid).queryOrdered(byChild: "diet").observe(.value, with: { snapshot in
                self.items = [Diet]()
                
               for item in snapshot.children {
                    let dietItem = Diet(snapshot: item as! FIRDataSnapshot)
                    //print(dietItem.diet)
                    //print(dietItem.dietSwitch)
                    self.items.append(dietItem)
                }
                
                if self.items.count == 0 {
                    self.items = self.diets
                    for d in self.diets {
                        self.saveDiet(diet: d)
                    }
                }
                ExcludedIngredients.diets = self.diets
                //self.items = self.diets
                self.tableView.reloadData()
                
            })
       }
        
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(hex: "d3d3d3")
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
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "   "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.init(hex: "d3d3d3")
        
        return returnedView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dietCell", for: indexPath) as!
        DietTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.dietLabel.text = self.items[indexPath.row].diet
        cell.dietCellSwitch.tag = indexPath.row
        cell.dietCellSwitch.isOn = self.items[indexPath.row].dietSwitch
        
        return cell
    }
    
    func saveDiet (diet:Diet) {
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            let diet = Diet(diet:diet.diet, dietSwitch:diet.dietSwitch)
        
            let dietItemRef = self.ref.child(uid).child((diet.diet.lowercased()))
        
            dietItemRef.setValue(diet.toAnyObject())
        }
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        let row = sender.tag
        let diet = items[row]
        diet.dietSwitch = sender.isOn
        print(diet.dietSwitch)
        saveDiet(diet: diet)
        ExcludedIngredients.diets[row].dietSwitch = sender.isOn
    }
}
