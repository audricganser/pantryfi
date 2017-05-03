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
    var summary:String
    
    
    
    init(id:Int = 0, title:String = "", image:String = "", usedIngredientCount:Int = 0, missedIngredientCount:Int = 0, likes:Int = 0, healthScore:Int = 0, spoonacularScore:Int = 0, servings:Int = 0, readyInMinutes:Int = 0, missedIngredients:[Ingredient] = [], usedIngredients:[Ingredient] = [], analyzedInstructions:AnalyzedInstructions = AnalyzedInstructions.init(), summary:String = "") {
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
        self.summary = summary
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "title": title,
            "image": image,
            "usedIngredientCount": usedIngredientCount,
            "missedIngredientCount": missedIngredientCount,
            "likes": likes,
            "healthScore": healthScore,
            "spoonacularScore": spoonacularScore,
            "servings": servings,
            "readyInMinutes": readyInMinutes,
            "missedIngredients": missedIngredients,
            "usedIngredients": usedIngredients,
            "analyzedInstructions": analyzedInstructions,
            "summary": summary
        ]
    }


}
