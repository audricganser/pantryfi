//
//  RecipeIngredientsTableViewController.swift
//  PantryFi
//
//  Created by david ares on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import Alamofire

class RecipeIngredientsTableViewController: UITableViewController {
    
    var ingredients = [Ingredient]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
        tableView.delegate = self
        tableView.dataSource = self
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
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! RecipeIngredientsTableViewCell
        // Configure the cell...
        let ingredient = self.ingredients[indexPath.row]
        print("image url \(ingredient.image)")
        // Loading image from url
        Alamofire.request(ingredient.image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                cell.imgView1.image = image
            } else {
                // place holder image
                // cell.imgView1.image = something!!!
                print("Data is nil. I don't know what to do :(")
            }
        }
        //cell.addButton.titleLabel?.textColor = UIColor.green
        //cell.addButton.setBackgroundImage(img, for: UIControlState.normal)
        cell.titleLabel.text = ingredient.name
        cell.quantityLabel.text = ingredient.quantity + " " + ingredient.unit
        cell.ingredient = ingredient
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: "showAlert:", for: UIControlEvents.touchUpInside)

        return cell
    }
    
    func showAlert(sender:UIButton!) {
        print(sender.tag)
        print("I was touched!")
        
    }
    

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
