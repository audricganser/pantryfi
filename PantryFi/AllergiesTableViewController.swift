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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let allergiesItem = items[indexPath.row]
        
        cell.textLabel?.text = allergiesItem.name
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let allergiesItem = items[indexPath.row]
            allergiesItem.ref?.removeValue()
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
                        }
                        
                    }
                }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
