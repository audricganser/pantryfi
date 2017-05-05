//
//  PantrySearchViewController.swift
//  PantryFi
//
//  Created by david ares on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Alamofire
import FirebaseAuth
import FirebaseDatabase

class PantrySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var ingredientsString = ""
    var scope:Int = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var listData = [[String: AnyObject]]()
    let ref = FIRDatabase.database().reference(withPath: "ingredients")
    var items = [String]()
    var recipeList1 = [RecipeWithIngredients]()
    
    var searchFromHome = false
    var queryFromHome = ""
    
     //var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIngredients()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        //tableView.tableFooterView?.backgroundColor = UIColor.init(hex: "d3d3d3")
        tableView.backgroundColor = UIColor.init(hex: "d3d3d3")
        
        splashText()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //print("editing scope is: \( self.scope)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print("clicked")
        self.recipeList1.removeAll()
        self.tableView.reloadData()
        print(searchBar.text!)
        let query = "\(searchBar.text!)"
        if self.scope == 1 {
            complexSearch(query: query)
        }
        else {
            
            complexSearch(query: query, includeIngredients: self.ingredientsString)
        }
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.scope = selectedScope
        print("scope was clicked: \(selectedScope)")
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeList1.count
    }
    
    func splashText() {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "No Results"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        print("building a new cell")
        // Configure the cell...
        let recipe = recipeList1[indexPath.row]
        
        // Configure the cell...
        // Loading image from url
        Alamofire.request(recipe.image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                cell.recipeImage.image = image
            } else {
                // place holder image
                // cell.imgView1.image = something!!!
                print("Data is nil. I don't know what to do :(")
            }
        }
        cell.recipeTitle.text = recipe.title
        cell.prepTimeLabel.text = "\(recipe.readyInMinutes) minutes"
        cell.ratingLabel.text = "\(recipe.spoonacularScore)"
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "recipeScreen", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "recipeScreen") as! RecipeViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        let recipe = recipeList1[indexPath!.row]
        vc.recipe = recipe
        //vc.callerVC = "searchResults"

        tableView.deselectRow(at: indexPath!, animated:true)
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)

    }


    
    //Get Pantry Items
    func getIngredients () {
        if let user = FIRAuth.auth()?.currentUser
        {
            let uid = user.uid
            ref.child(uid).observe(.value, with: { snapshot in
                // 2
                var newItems: [String] = []
                
                // 3
                for item in snapshot.children {
                    // 4
                    let groceryItem = Ingredient(snapshot: item as! FIRDataSnapshot)
                    newItems.append(groceryItem.name)
                }
                
                // 5
                self.items = newItems
                self.ingredientsString = newItems.joined(separator: ",")
                //print(self.ingredientsString)
                self.complexSearch(includeIngredients: self.ingredientsString )
            })
        }
    }
    
    // API Complex Recipe Search Function
    func complexSearch (query:String = "", includeIngredients: String = "", excludeIngredients: String = "", intolerances: String = "", number: Int = 10, offset: Int = 0, type: String = "") {
        
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        let parameters: Parameters = ["addRecipeInformation": "true",
                                      "instructionsRequired": "true",
                                      "limitLicense": "true",
                                      "fillIngredients": "true",
                                      "includeIngredients": includeIngredients,
                                      "excludeIngredients": excludeIngredients,
                                      "intolerances": intolerances,
                                      "number": number,
                                      "offset": offset,
                                      "query": query]
        
        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
        
            if let JSON = response.result.value {
                let jsonDict = JSON as! Dictionary<String, Any>
                let results = jsonDict["results"] as! NSArray
                // print(results)
                self.recipeList1 = []
                for recipe in results {
                    let newRecipe = RecipeWithIngredients.getRecipe(recipe: recipe as! Dictionary<String, Any>)
                    self.recipeList1.append(newRecipe)
                    
                }
                self.tableView.reloadData()
                
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "recipeSegue") {
            let destinationVC = segue.destination as! RecipeViewController
            let indexPath = tableView.indexPathForSelectedRow
            let recipe = recipeList1[indexPath!.row]
            destinationVC.recipe = recipe
        }

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
