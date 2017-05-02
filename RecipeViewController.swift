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

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipePrepTime: UILabel!
    @IBOutlet weak var recipeServes: UILabel!
    @IBOutlet weak var missingIngredients: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
    var recipe:RecipeWithIngredients = RecipeWithIngredients.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading image from url
        Alamofire.request(self.recipe.image).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                self.recipeImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }

        // Do any additional setup after loading the view.
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
    
    @IBAction func showNutrition(_ sender: Any) {
        
    }
    
    @IBAction func showSummary(_ sender: Any) {
        
    }
    
    @IBAction func showInstructions(_ sender: Any) {
        
    }
    

}
