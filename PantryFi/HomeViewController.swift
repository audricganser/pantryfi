//
//  HomeViewController.swift
//  PantryFi
//
//  Created by david ares on 3/19/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    var items = [Ingredient]()

    @IBOutlet weak var pantrySearchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    let addCellIdentifier = "addCell"
    let itemIdentifier = "itemCell"
    let ref = FIRDatabase.database().reference(withPath: "ingredients")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PantryFi"
   
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "menu-button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(SSASideMenu.presentRightMenuViewController), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        //pantrySearchButton.layer.borderColor = UIColor.white.cgColor
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [Ingredient] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let groceryItem = Ingredient(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            // 5
            self.items = newItems
            self.tableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSearchBar()
    {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for your recipe"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(items.count == 0)
        {
            return 1
        }
        else
        {
            return items.count + 1
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
            let ingredient = items[row-1]
            itemCell.titleLabel.text = ingredient.name
            itemCell.quantityLabel.text = ingredient.quantity

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
                        guard let textField = alert.textFields?.first,
                            let text = textField.text else { return }
                        
                        // 2
                        let ingredient = Ingredient(name:text, quantity:itemQuantity)
                        // 3
                        let ingredientItemRef = self.ref.child(text.lowercased())
                        
                        // 4
                        ingredientItemRef.setValue(ingredient.toAnyObject())
                        
                        
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            return
        }
        if editingStyle == .delete {
            let ingredientItem = items[indexPath.row-1]
            ingredientItem.ref?.removeValue()
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

