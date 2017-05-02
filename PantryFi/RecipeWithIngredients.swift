//
//  RecipeWithIngredients.swift
//  PantryFi
//
//  Created by david ares on 4/16/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation

class RecipeWithIngredients {
    var id:Int
    var title:String
    var image:String
    var usedIngredientCount:Int
    var missedIngredientCount:Int
    var likes:Int
    var healthScore:Int
    var spoonacularScore:Int
    var servings:Int
    var readyInMinutes:Int
    var missedIngredients:[Ingredient]
    var usedIngredients:[Ingredient]
    var analyzedInstructions:AnalyzedInstructions
    
    
    
    init(id:Int, title:String, image:String, usedIngredientCount:Int, missedIngredientCount:Int, likes:Int, healthScore:Int, spoonacularScore:Int, servings:Int, readyInMinutes:Int, missedIngredients:[Ingredient], usedIngredients:[Ingredient], analyzedInstructions:AnalyzedInstructions) {
        self.id = id
        self.title = title
        self.image = image
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        self.likes = likes
        self.healthScore = healthScore
        self.spoonacularScore = spoonacularScore
        self.servings = servings
        self.readyInMinutes = readyInMinutes
        self.missedIngredients = missedIngredients
        self.usedIngredients = usedIngredients
        self.analyzedInstructions = analyzedInstructions
    }
    

}
