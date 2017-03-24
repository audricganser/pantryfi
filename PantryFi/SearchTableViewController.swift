//
//  SearchTableViewController.swift
//  PantryFi
//
//  Created by RAZA on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    let searchController = UISearchController(searchResultsController: nil)
    //var detailViewController: DetailViewController? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Fish", "Chicken", "Beef"]
        tableView.tableHeaderView = searchController.searchBar
        
        recipes = [
            Recipe(category:"Fish", name:"Grilled Salmon"),
            Recipe(category:"Fish", name:"Fried Cod"),
            Recipe(category:"Chicken", name:"Grilled Steak"),
            Recipe(category:"Beef", name:"Angus Steak"),
            Recipe(category:"Milk", name:"Hot Cocoa"),
            Recipe(category:"Eggs", name:"Mushroom Omelette"),
            Recipe(category:"Chicken", name:"Fried Chicken"),
            Recipe(category:"Chicken", name:"Sour Chew"),
            Recipe(category:"Eggs", name:"Scrammled Eggs")]
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            //detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRecipes.count
        }
        return recipes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)

        var recipe: Recipe? = nil
        if searchController.isActive && searchController.searchBar.text != "" {
            recipe = filteredRecipes[indexPath.row]
        } else {
            recipe = recipes[indexPath.row]
        }
        cell.textLabel!.text = recipe?.name
        cell.detailTextLabel!.text = recipe?.category
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRecipes = recipes.filter({( recipe : Recipe) -> Bool in
            let categoryMatch = (scope == "All") || (recipe.category == scope)
            return categoryMatch && recipe.name.localizedLowercase.contains(searchText.localizedLowercase)
        })
        tableView.reloadData()
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

extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}
