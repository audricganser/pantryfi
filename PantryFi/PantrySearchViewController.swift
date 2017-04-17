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

class PantrySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var recipeList = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    var listData = [[String: AnyObject]]()
    
    var recipeList1 = [RecipeWithIngredients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // API call for recipes
        searchRecipes()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // API Search Function
    func searchRecipes () {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        let parameters: Parameters = ["fillIngredients": "false", "limitLicense":"true", "number": 10, "ranking": 1, "ingredients": "apples,flour,sugar,chicken,rice,broccoli"]
        
        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let jsonArray = JSON as! NSArray
                
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
    
    // Get Recipe Summary
    func recipeSummary (id: String, cell: RecipeResultTableViewCell) {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + "\(id)" + "/summary"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        var summary = ""
        Alamofire.request(baseUrl, headers: headers).responseJSON { response in
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let json = JSON as! Dictionary<String, Any>
                let sum = json["summary"]!
                summary = "\(sum)"
                cell.recipeDescript.text = summary
                //print("JSON: \(summary)")
                
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
            destinationVC.recipeImageSegue = recipe.image
            destinationVC.recipeNameSegue = recipe.title
            destinationVC.recipePrepTimeSegue = "10 mins"
            destinationVC.recipeServesSegue = "2 servings"
            destinationVC.recipeIdSegue = recipe.id
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
