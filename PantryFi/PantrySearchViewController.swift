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
import FirebaseDatabase

class PantrySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //private var recipeList = [NSManagedObject]()
    var ingredientsString = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var listData = [[String: AnyObject]]()
    let ref = FIRDatabase.database().reference(withPath: "ingredients")
    var recipeList1 = [RecipeWithIngredients]()
    
     //var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // API call for recipes
        searchPantryRecipes()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editing")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        print(searchBar.text!)
        let query = "\(searchBar.text!)"
        searchStringRecipe(query: query)
        
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        print("building a new cell")
        // Configure the cell...
        let recipe = recipeList1[indexPath.row]
        
        // Getting summary
        recipeSummary(id: recipe.id, cell: cell)
        
        let title = recipe.title
        //let descript = recipe.id
        let imageUrl = recipe.image
        
        // Configure the cell...
        cell.recipeDescript.textColor = UIColor.gray
        cell.recipeTitle.text = title
        cell.recipeDescript.text = "Loading..."
        //cell.recipeDescript.text = descript
        
        // Loading image from url
        Alamofire.request(imageUrl).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                cell.recipeImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
        
        return cell
    }
    
    func getIngredients () -> [Ingredient] {
        var items:[Ingredient] = []
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            
            // 3
            for item in snapshot.children {
                // 4
                let groceryItem = Ingredient(snapshot: item as! FIRDataSnapshot)
                items.append(groceryItem)
            }
          
        })
        return items
    }
    
    // API Search Function
    func searchPantryRecipes () {
        print ("ingredients are: \(self.ingredientsString) ")
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        let parameters: Parameters = ["fillIngredients": "false", "limitLicense":"true", "number": 10, "ranking": 1, "ingredients": self.ingredientsString]
        
        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let jsonArray = JSON as! NSArray
                
                self.recipeList1 = []
                for recipe in jsonArray {
                    let recipeObj = recipe as! Dictionary<String, Any>
                    let recipeId = recipeObj["id"]!
                    let recipeTitle = recipeObj["title"]!
                    let uic = recipeObj["usedIngredientCount"]!
                    let mic = recipeObj["missedIngredientCount"]!
                    let likes = recipeObj["likes"]!
                    let img = recipeObj["image"]!
                    
                    let newRecipe = RecipeWithIngredients.init(id: "\(recipeId)", title: "\(recipeTitle)", image: "\(img)", usedIngredientCount: uic as! Int, missedIngredientCount: mic as! Int, likes: likes as! Int)
                    
                    self.recipeList1.append(newRecipe)
                    print("appending recipe")
                    print(newRecipe.id)
                    print(newRecipe.title)
                }
                self.tableView.reloadData()
                
            }
        }
    }
    
    func searchStringRecipe (query:String) {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        let parameters: Parameters = ["instructionsRequired": "false", "limitLicense":"true", "number": 10, "offset": 0, "query": query]
        
        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            //            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let jsonDict = JSON as! Dictionary<String, Any>
                let results = jsonDict["results"] as! NSArray
                
                self.recipeList1 = []
                for recipe in results {
                    let recipeObj = recipe as! Dictionary<String, Any>
                    let recipeId = recipeObj["id"]!
                    let recipeTitle = recipeObj["title"]!
                    let uic = 0
                    let mic = 1
                    let likes = 0
                    let img = recipeObj["image"]!
                    let image = "https://spoonacular.com/recipeImages/" + "\(img)"
 
                    let newRecipe = RecipeWithIngredients.init(id: "\(recipeId)", title: "\(recipeTitle)", image: image, usedIngredientCount: uic , missedIngredientCount: mic , likes: likes)
                    
                    self.recipeList1.append(newRecipe)
                    print("appending recipe")
                    print(newRecipe.id)
                    print(newRecipe.title)
                }
                self.tableView.reloadData()
                
            }
        }
    
    }
    
    
    // Get Recipe Summary
    func recipeSummary (id: String, cell: RecipeResultTableViewCell) {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + "\(id)" + "/summary"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        var summary = ""
        Alamofire.request(baseUrl, headers: headers).responseJSON { response in
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            // print(response.data)     // server data
            // print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let json = JSON as! Dictionary<String, Any>
                let sum = json["summary"]!
                summary = "\(sum)"
                cell.recipeDescript.attributedText = self.stringFromHtml(string: summary)
                //print("JSON: \(summary)")
                
            }
        }
    }
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
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
            destinationVC.recipeImageSegue = recipe.image
            destinationVC.recipeNameSegue = recipe.title
            destinationVC.recipePrepTimeSegue = "10 mins"
            destinationVC.recipeServesSegue = "2 servings"
            destinationVC.recipeIdSegue = recipe.id
            destinationVC.missingIngrSegue = recipe.missedIngredientCount
            destinationVC.containsIngSegue = recipe.usedIngredientCount
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
