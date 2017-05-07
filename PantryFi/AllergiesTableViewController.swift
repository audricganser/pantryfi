//
//  AllergiesTableViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AllergiesTableViewController: UITableViewController {
    
    var items = [Allergies]()
    var ref = FIRDatabase.database().reference(withPath: "allergiesList")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashText()
        
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            
            ref.child(uid).queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
                var newItems: [Allergies] = []
                
                for item in snapshot.children {
                    let allergiesItem = Allergies(snapshot: item as! FIRDataSnapshot)
                    newItems.append(allergiesItem)
                }
                
                self.items = newItems
                self.tableView.reloadData()
            })
        }
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(hex: "d3d3d3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func splashText() {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "Add Allergies"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   "
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.init(hex: "d3d3d3")
        
        return returnedView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundView  = nil
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let allergiesItem = items[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.textLabel?.text = allergiesItem.name
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let allergiesItem = items[indexPath.row]
            allergiesItem.ref?.removeValue()
            ExcludedIngredients.allergies.remove(at: indexPath.row)
            if tableView.visibleCells.count == 1 {
                splashText()
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Allergin", message:"Insert Your Allergin", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].placeholder = "Allergin"
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                if(title == "")
                {
                        
                }
                else
                {
                    guard let textField = alert.textFields?.first,
                    let text = textField.text else { return }
                        
                    if let user = FIRAuth.auth()?.currentUser
                    {
                        let uid = user.uid
                            
                        // 2
                        let allergies = Allergies(name:text)
                        // 3
                        let allergiesItemRef = self.ref.child(uid).child(text.lowercased())
                            
                        // 4
                        allergiesItemRef.setValue(allergies.toAnyObject())
                        ExcludedIngredients.allergies = self.items
                    }
                        
                    }
                }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
