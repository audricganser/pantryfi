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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editing scope is: \( self.scope)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeResult", for: indexPath) as! RecipeResultTableViewCell
        print("building a new cell")
        // Configure the cell...
        let recipe = recipeList1[indexPath.row]
        
        // Getting summary
        //recipeSummary(id: "\(recipe.id)", cell: cell)
        
        let title = recipe.title
        //let descript = recipe.id
        let imageUrl = recipe.image
        
        // Configure the cell...
        cell.recipeDescript.textColor = UIColor.gray
        cell.recipeTitle.text = title
        //cell.recipeTitle.textColor = UIColor.white
        //cell.recipeTitle.backgroundColor = UIColor(red: 76.0, green: 210.0, blue: 132.0, alpha: 0.0)
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "recipeScreen", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "recipeScreen") as! RecipeViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        let recipe = recipeList1[indexPath!.row]
        vc.recipeImageSegue = recipe.image
        vc.recipeNameSegue = recipe.title
        vc.recipePrepTimeSegue = "10 mins"
        vc.recipeServesSegue = "2 servings"
        vc.recipeIdSegue = "\(recipe.id)"
        vc.missingIngrSegue = recipe.missedIngredientCount
        vc.containsIngSegue = recipe.usedIngredientCount

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
                print(self.ingredientsString)
                self.complexSearch(includeIngredients: self.ingredientsString )
            })
        }
        
        
//        // API call for recipes
//        searchPantryRecipes()
//        
//        //search from the home VC
//        if searchFromHome {
//            searchStringRecipe(query: queryFromHome)
//        }
//
    }
    
    // API Search Function
//    func searchPantryRecipes () {
//        self.ingredientsString = self.items.joined(separator: ",")
//        print ("ingredients are: \(self.ingredientsString) ")
//        
//        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients"
//        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
//        let parameters: Parameters = ["fillIngredients": "false", "limitLicense":"true", "number": 10, "ranking": 1, "ingredients": self.ingredientsString]
//        
//        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
////            print(response.request)  // original URL request
////            print(response.response) // HTTP URL response
////            print(response.data)     // server data
////            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                let jsonArray = JSON as! NSArray
//                
//                self.recipeList1 = []
//                for recipe in jsonArray {
//                    let recipeObj = recipe as! Dictionary<String, Any>
//                    let recipeId = recipeObj["id"]!
//                    let recipeTitle = recipeObj["title"]!
//                    let uic = recipeObj["usedIngredientCount"]!
//                    let mic = recipeObj["missedIngredientCount"]!
//                    let likes = recipeObj["likes"]!
//                    let img = recipeObj["image"]!
//                    
//                    let newRecipe = RecipeWithIngredients.init(id: "\(recipeId)", title: "\(recipeTitle)", image: "\(img)", usedIngredientCount: uic as! Int, missedIngredientCount: mic as! Int, likes: likes as! Int)
//                    
//                    self.recipeList1.append(newRecipe)
//                    print("appending recipe")
//                    print(newRecipe.id)
//                    print(newRecipe.title)
//                }
//                self.tableView.reloadData()
//                
//            }
//        }
//    }
    
//    func searchStringRecipe (query:String) {
//        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search"
//        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
//        let parameters: Parameters = ["instructionsRequired": "false", "limitLicense":"true", "number": 10, "offset": 0, "query": query]
//        
//        Alamofire.request(baseUrl, parameters: parameters, headers: headers).responseJSON { response in
//            //            print(response.request)  // original URL request
//            //            print(response.response) // HTTP URL response
//            //            print(response.data)     // server data
//            //            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                let jsonDict = JSON as! Dictionary<String, Any>
//                let results = jsonDict["results"] as! NSArray
//                
//                self.recipeList1 = []
//                for recipe in results {
//                    let recipeObj = recipe as! Dictionary<String, Any>
//                    let recipeId = recipeObj["id"]!
//                    let recipeTitle = recipeObj["title"]!
//                    let uic = 0
//                    let mic = 1
//                    let likes = 0
//                    let img = recipeObj["image"]!
//                    let image = "https://spoonacular.com/recipeImages/" + "\(img)"
// 
//                    let newRecipe = RecipeWithIngredients.init(id: "\(recipeId)", title: "\(recipeTitle)", image: image, usedIngredientCount: uic , missedIngredientCount: mic , likes: likes)
//                    
//                    self.recipeList1.append(newRecipe)
//                    print("appending recipe")
//                    print(newRecipe.id)
//                    print(newRecipe.title)
//                }
//                self.tableView.reloadData()
//                
//            }
//        }
//    
//    }
    
    /*
     curl --get --include 'https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex?
     addRecipeInformation=true& cuisine=american& diet=pescetarian& excludeIngredients=coconut%2C+mango& fillIngredients=true& 
     includeIngredients=onions%2C+lettuce%2C+tomato& 
     instructionsRequired=false& 
     intolerances=peanut%2C+shellfish&
     limitLicense=true&
     number=10&
     offset=0&
     query=burger&
     ranking=1&
     type=main+course' \
     -H 'X-Mashape-Key: oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg' \
     -H 'Accept: application/json'
 */
    
    
    
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
                print(results)
                self.recipeList1 = []
                for recipe in results {
                    let newRecipe = self.getRecipe(recipe: recipe as! Dictionary<String, Any>)
                    self.recipeList1.append(newRecipe)
                    print("appending recipe")
                    print(newRecipe.id)
                    print(newRecipe.title)
                }
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func getRecipe(recipe: Dictionary<String, Any>) -> RecipeWithIngredients {
        let id:Int = recipe["id"]! as! Int
        let title = recipe["title"]!
        let image = recipe["image"]!
        let usedIngredientCount:Int = recipe["usedIngredientCount"]! as! Int
        let missedIngredientCount:Int = recipe["missedIngredientCount"]! as! Int
        let likes:Int = recipe["likes"]! as! Int
        let healthScore:Int = recipe["healthScore"]! as! Int
        let spoonacularScore:Int = recipe["spoonacularScore"]! as! Int
        let servings:Int = recipe["servings"]! as! Int
        let readyInMinutes:Int = recipe["readyInMinutes"]! as! Int
        var missedIngredients:[Ingredient] = [Ingredient]()
        for i in recipe["missedIngredients"]! as! NSArray {
            missedIngredients.append(makeIngredient(ingredient: i as! Dictionary<String, Any>))
        }
        
        var usedIngredients:[Ingredient] = [Ingredient]()
        for i in recipe["usedIngredients"]! as! NSArray {
            usedIngredients.append(makeIngredient(ingredient: i as! Dictionary<String, Any>))
        }

        var ai = recipe["analyzedInstructions"]! as! NSArray
        let analyzedInstructions:AnalyzedInstructions = makeAnalyzedInstructions(analyzedInstructions: ai[0] as! Dictionary<String, Any>)
        
        let recipe_ret = RecipeWithIngredients.init(id: id, title: "\(title)", image: "\(image)", usedIngredientCount: usedIngredientCount, missedIngredientCount: missedIngredientCount, likes: likes, healthScore: healthScore, spoonacularScore: spoonacularScore, servings: servings, readyInMinutes: readyInMinutes, missedIngredients: missedIngredients, usedIngredients: usedIngredients, analyzedInstructions: analyzedInstructions)

        print(recipe_ret)
        return recipe_ret
    }
    
    func makeIngredient (ingredient: Dictionary<String, Any>) -> Ingredient {
        let name = ingredient["name"]!
        let quantity = ingredient["amount"]!
        let key = ingredient["id"]!
        
        return Ingredient.init(name: "\(name)", quantity: "\(quantity)", key: "\(key)")
    }
    
    func makeAnalyzedInstructions (analyzedInstructions: Dictionary<String, Any>) -> AnalyzedInstructions {
        let name = analyzedInstructions["name"]!
        var steps = [Steps]()
        for s in analyzedInstructions["steps"]! as! NSArray {
            let step = s as! Dictionary<String, Any>
            let number = step["number"]! as! Int
            let step1 = step["step"]!
            steps.append(Steps.init(number: number, step: "\(step1)"))
            
        }
        return AnalyzedInstructions.init(name: "\(name)", steps: steps)
        
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
            destinationVC.recipeIdSegue = "\(recipe.id)"
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
