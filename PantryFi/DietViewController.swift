//
//  DietViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/17/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class DietViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {

    //var allergies = ["Milk", "Eggs", "Fish", "Crustacean shellfish", "Tree Nuts", "Peanuts", "Wheat", "Soybeans", "Gluten", "Soy", "Sulfite"]
    @IBOutlet weak var tableView: UITableView!
    
    var diets = ["Vegan", "Vegetarian", "Gluten Free", "Ketogenic", "Whole 30", "Paleo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.diets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dietCell", for: indexPath) as!
        DietTableViewCell
        
        cell.dietLabel.text = diets[indexPath.row]
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated:true)
    //
    //        let row = indexPath.row
    //        if(row == 0)
    //        {
    //            didTapAddItem()
    //        }
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
