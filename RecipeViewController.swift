//
//  RecipeViewController.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/24/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import Alamofire

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeServes: UILabel!
    @IBOutlet weak var missingIngredients: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
    var recipe:RecipeWithIngredients = RecipeWithIngredients.init()
    let ref = FIRDatabase.database().reference(withPath: "recipes")
    var recipeFromFavs = false
    var recipeId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if recipeFromFavs {
            print("recipe was saved in favorites")
            print(recipeId)
        }
        else {
            fillLabels()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Get Recipe Summary
    func recipeSummary (id: Int) {
        let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + "\(id)" + "/summary"
        let headers: HTTPHeaders = ["X-Mashape-Key": "oWragx4kwsmshOw6ZL8IH8RP81DUp1L0QFVjsn0JaX9pEIPpUg"]
        var summary = ""
        Alamofire.request(baseUrl, headers: headers).responseJSON { response in
            if let JSON = response.result.value {
                let json = JSON as! Dictionary<String, Any>
                let sum = json["summary"]!
                summary = "\(sum)"
                self.recipe.summary = summary
            }
        }
    }
    
    func fillLabels () {
        // Loading image from url
        Alamofire.request(self.recipe.image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                self.recipeImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
        // Filling labels with recipe values
        self.recipeTitle.text = self.recipe.title
        self.recipePrepTime.text = "\(self.recipe.readyInMinutes) minutes"
        self.recipeServes.text = "\(self.recipe.servings)"
        self.ratingLabel.text = "\(self.recipe.spoonacularScore)"
        self.healthScoreLabel.text = "\(self.recipe.healthScore)"
        if self.recipe.missedIngredientCount > 0 {
            self.missingIngredients.text = "Pantry contains " + "\(self.recipe.usedIngredientCount)"
        }
        else {
            self.missingIngredients.text = "Pantry contains all"
        }
        // setting recipe summary
        recipeSummary(id: self.recipe.id)
        
    }
    
    
    @IBAction func showIngredients(_ sender: Any) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "Recipe-Ingredients", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "recipeIngredients") as! RecipeIngredientsTableViewController
        
        var i = [Ingredient]()
        i.append(contentsOf: self.recipe.missedIngredients)
        i.append(contentsOf: self.recipe.usedIngredients)
//        i.append(self.recipe.missedIngredients)
//        i.append(self.recipe.usedIngredients)
        vc.ingredients = i
        
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func favoriteRecipe(_ sender: Any) {
        
        let title = self.recipe.title
        

                    if let user = FIRAuth.auth()?.currentUser
                        {
                            let uid = user.uid
                            let recipe = self.recipe
                            
                            let recipeRef = self.ref.child(uid).child(title.lowercased())
                            
                            recipeRef.setValue(recipe.toAnyObject())
                            
                            let alert = UIAlertController(title: "Success", message:"The item was added to your favorites", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                
                            }))
                            self.present(alert, animated: true, completion:nil)
                        }
        
        
        
    }
    
    @IBAction func showSummary(_ sender: Any) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "RecipeSummary", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "recipeSummary") as! RecipeSummaryViewController
        
        vc.recipe = self.recipe
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    
    @IBAction func showInstructions(_ sender: Any) {
        let storyBoard1:UIStoryboard = UIStoryboard(name: "RecipeInstructions", bundle:nil)
        let vc = storyBoard1.instantiateViewController(withIdentifier: "recipeInstructions") as! RecipeInstructionsTableViewController
        
        var steps = [Steps]()
        steps.append(contentsOf: self.recipe.analyzedInstructions.steps)
        vc.steps = steps
        
        //go to other view controller
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    

}
