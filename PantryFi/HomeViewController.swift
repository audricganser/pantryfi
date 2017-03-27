//
//  HomeViewController.swift
//  PantryFi
//
//  Created by david ares on 3/19/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredients = [NSManagedObject]()

    @IBOutlet weak var pantrySearchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let addCellIdentifier = "addCell"
    let itemIdentifier = "itemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pantrySearchButton.layer.borderColor = UIColor.white.cgColor
        self.navigationItem.title = "PantryFi"
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(ingredients.count == 0)
        {
            return 1
        }
        else
        {
            return ingredients.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0)
        {
            let addCell = tableView.dequeueReusableCell(withIdentifier: addCellIdentifier) as! AddIngredientTableViewCell
            addCell.backgroundColor = UIColor.clear

            return addCell
        }
        else
        {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier) as! IngredientTableViewCell
            itemCell.backgroundColor = UIColor.clear
            
            //quantity label background color
            //itemCell.quantityLabel.backgroundColor = UIColor.black
            let row = indexPath.row
            let ingredient = ingredients[row-1]
            itemCell.titleLabel.text = ingredient.value(forKey: "name") as? String
            itemCell.quantityLabel.text = ingredient.value(forKey: "quantity") as? String

            return itemCell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let row = indexPath.row
        if(row == 0)
        {
            didTapAddItem()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 80
    }
    
    
    
    func didTapAddItem()
    {
        let alert = UIAlertController(title: "New Ingredient", message:"Insert name of item and quantity", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                if let itemQuantity = alert.textFields?[1].text
                {
                    if(title == "" || itemQuantity == "")
                    {
            
                    }
                    else
                    {
                        self.saveIngredient(name: title, quantity: itemQuantity)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func saveIngredient(name: String, quantity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create the entity we want to save
        let entity =  NSEntityDescription.entity(forEntityName: "Ingredient", in: managedContext)
        
        let ingredient = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        // Set the attribute values
        ingredient.setValue(name, forKey: "name")
        ingredient.setValue(quantity, forKey: "quantity")
        
        
        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // Add the new entity to our array of managed objects
        ingredients.append(ingredient)
        tableView.reloadData()
    }
    
    fileprivate func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Ingredient")
        
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
            ingredients = results
        } else {
            print("Could not fetch")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
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
