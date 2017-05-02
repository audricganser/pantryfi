//
//  AllergiesViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 4/17/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class AllergiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topNavigation:UINavigationItem!
    var allergies = ["Milk", "Eggs", "Fish", "Crustacean shellfish", "Tree Nuts", "Peanuts", "Wheat", "Soybeans", "Gluten", "Soy", "Sulfite"]
    
    var diets = ["Vegan", "Vegetarian", "Gluten Free", "Ketogenic", "Whole 30", "Paleo"]
    
    var tableCellList = [String]()
    var listSegue = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if listSegue {
            self.tableCellList = self.allergies

        }
        else {
            self.tableCellList = self.diets
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func applyButton(_ sender: Any) {
        print("Save data and go back to userProfile")
        let storyBoard : UIStoryboard = UIStoryboard(name: "userProfiles", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "userProfiles") as!UserProfileTableViewController
        self.navigationController?.pushViewController(vc, animated:true)
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
        return self.tableCellList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let allerginCell = tableView.dequeueReusableCell(withIdentifier: "allerginCell", for: indexPath) as!
        AllergieTableViewCell
        
        allerginCell.allerginLabel.text = self.tableCellList[indexPath.row]
        
        return allerginCell
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
