//
//  RecipeViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeServes: UILabel!
    @IBOutlet weak var missingIngredients: UILabel!
    
    var recipeImageSegue:String?
    var recipeNameSegue:String?
    var recipePrepTimeSegue:String?
    var recipeServesSegue:String?
    var recipeIdSegue:String?
    var missingIngrSegue:Int?
    var containsIngSegue:Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    var ingredientsList = [Ingredient]()
    var prepStepsList = [Steps]()
    
    //private var iList = [Dictionary<String,String>]()
    
//    private var i1:Dictionary<String,String> = ["title":"Salmon","serving":"1 lbs"]
//    private var i2:Dictionary<String,String> = ["title":"Lemon","serving":"1"]
//    private var i3:Dictionary<String,String> = ["title":"Spinach","serving":"0.5 lbs"]
//    private var i4:Dictionary<String,String> = ["title":"Rice","serving":"2 lbs"]
//    private var i5:Dictionary<String,String> = ["title":"Pasta","serving":"0.75 lbs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading image from url
        Alamofire.request(self.recipeImageSegue!).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                self.recipeImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }

        // Do any additional setup after loading the view.
        self.recipeName.text = self.recipeNameSegue!
        
        if missingIngrSegue! > 0 {
            self.missingIngredients.text = "Pantry contains " + "\(self.containsIngSegue!)"
        }
        else {
            self.missingIngredients.text = "Pantry contains all"
        }
        //self.missingIngredients.text = "
//        self.recipePrepTime.text = self.recipePrepTimeSegue!
//        self.recipeServes.text = self.recipeServesSegue!
        
        
        // new request!
        // get Analyzed Recipe Instructions
        getRecipeInfo(id:recipeIdSegue!)
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
        return self.ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.ingredientsList[indexPath.row].name
        cell.detailTextLabel?.text = self.ingredientsList[indexPath.row].quantity
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getRecipeInfo (id: String) {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + "\(id)" + "/information"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        
        Alamofire.request(baseUrl, headers: headers).responseJSON { response in
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                let json = JSON as! Dictionary<String, Any>
                //print("info: \(JSON)")
                let servings = json["servings"]!
                let prepTime = json["readyInMinutes"]!
                self.recipeServes.text = "\(servings)"
                self.recipePrepTime.text = "\(prepTime)" + " minutes"
                
                let ingredients = json["extendedIngredients"] as! NSArray
                for i in ingredients {
                    let ingredient = i as! Dictionary<String, Any>
                    let id = ingredient["id"]!
                    let name = ingredient["name"]!
                    let amount = ingredient["amount"]!
                    let unit = ingredient["unit"]!
                    let quantity = "\(amount)" + " " + "\(unit)"
                    self.ingredientsList.append(Ingredient.init(name: "\(name)", quantity: "\(quantity)", key: "\(id)"))
                    
                    /*
                     "id": 5006,
                     "aisle": "Meat",
                     "image": "https://spoonacular.com/cdn/ingredients_100x100/whole-chicken.jpg",
                     "name": "chicken",
                     "amount": 1,
                     "unit": "serving",
                     "unitShort": "serving",
                     "unitLong": "serving",
                     "originalString": "to taste cooked, sliced chicken, cooked onions, red peppers, chop",
                     "metaInformation": [
                     "red",
                     "cooked",
                     "sliced",
                     "to taste"
                     ]
                     */
                }
                self.tableView.reloadData()
                
                let instruct = json["analyzedInstructions"] as! NSArray
                let instruct1 = instruct[0] as! Dictionary<String, Any>
                let steps = instruct1["steps"] as! NSArray
                
                for step in steps {
                    let step1 = step as! Dictionary<String, Any>
                    let stepString = step1["step"]!
                    self.prepStepsList.append(Steps.init(number: step1["number"]! as! Int, step: "\(stepString)"))
                }
                //self.tableView.reloadData()
            }
 
 
        }
        
    }

}
