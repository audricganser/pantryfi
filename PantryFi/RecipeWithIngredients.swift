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
    
    static func getRecipe(recipe: Dictionary<String, Any>) -> RecipeWithIngredients {
        var id = 0
        if let idVal = recipe["id"] { id = idVal as! Int }
        var title = ""
        if let titleVal = recipe["title"] { title = "\(titleVal)" }
        var image = ""
        if let imageVal = recipe["image"] { image = "\(imageVal)" }
        var usedIngredientCount = 0
        if let uicVal = recipe["usedIngredientCount"] { usedIngredientCount = uicVal as! Int }
        var missedIngredientCount = 0
        if let micVal = recipe["missedIngredientCount"] { missedIngredientCount = micVal as! Int }
        var likes = 0
        if let likesVal = recipe["likes"] { likes = likesVal as! Int }
        var healthScore = 0
        if let hsVal = recipe["healthScore"] { healthScore = hsVal as! Int }
        var spoonacularScore = 0
        if let sVal = recipe["spoonacularScore"] { spoonacularScore = sVal as! Int }
        var servings = 0
        if let serVal = recipe["servings"] { servings = serVal as! Int }
        var readyInMinutes = 0
        if let rimVal = recipe["readyInMinutes"] { readyInMinutes = rimVal as! Int }
        
        var missedIngredients:[Ingredient] = [Ingredient]()
        if let _ = recipe["missedIngredients"] {
            for i in recipe["missedIngredients"]! as! NSArray {
                missedIngredients.append(self.makeIngredient(ingredient: i as! Dictionary<String, Any>))
            }
        }
        
        var usedIngredients:[Ingredient] = [Ingredient]()
        if let _ = recipe["usedIngredients"] {
            for i in recipe["usedIngredients"]! as! NSArray {
                usedIngredients.append(self.makeIngredient(ingredient: i as! Dictionary<String, Any>))
            }
        }
        
        var analyzedInstructions:AnalyzedInstructions = AnalyzedInstructions.init()
        if let _ = recipe["analyzedInstructions"] {
            let ai = recipe["analyzedInstructions"]! as! NSArray
            if ai.count > 0 {
                analyzedInstructions = self.makeAnalyzedInstructions(analyzedInstructions: ai[0] as! Dictionary<String, Any>)
            }
        }
        
        return RecipeWithIngredients.init(id: id, title: title, image: image, usedIngredientCount: usedIngredientCount, missedIngredientCount: missedIngredientCount, likes: likes, healthScore: healthScore, spoonacularScore: spoonacularScore, servings: servings, readyInMinutes: readyInMinutes, missedIngredients: missedIngredients, usedIngredients: usedIngredients, analyzedInstructions: analyzedInstructions)
    }
    
    static func makeIngredient (ingredient: Dictionary<String, Any>) -> Ingredient {
        var name = ""
        if let nameVal = ingredient["name"] { name = "\(nameVal)" }
        var amount = ""
        if let amountVal = ingredient["amount"] { amount = "\(amountVal)" }
        var unit = ""
        if let unitVal = ingredient["unitLong"] { unit = "\(unitVal)" }
        var key = ""
        if let keyVal = ingredient["key"] { key = "\(keyVal)" }
        var image = ""
        if let imageVal = ingredient["image"] { image = "\(imageVal)" }
        return Ingredient.init(name: name, quantity: amount, key: key, unit: unit, image: image)
    }
    
    static func makeAnalyzedInstructions (analyzedInstructions: Dictionary<String, Any>) -> AnalyzedInstructions {
        var name = ""
        if let nameVal = analyzedInstructions["name"] { name = "\(nameVal)" }
        var steps = [Steps]()
        if let _ = analyzedInstructions["steps"] {
            for s in analyzedInstructions["steps"]! as! NSArray {
                let step = s as! Dictionary<String, Any>
                var number = 0
                if let numVal = step["number"] { number = numVal as! Int }
                var stepText = ""
                if let stepVal = step["step"] { stepText = "\(stepVal)" }
                steps.append(Steps.init(number: number, step: stepText))
            }
        }
        var ingredients = [Ingredient]()
        if let _ = analyzedInstructions["ingredients"] {
            for i in analyzedInstructions["ingredients"]! as! NSArray {
                let ingredient = self.makeIngredient(ingredient: i as! Dictionary<String, Any>)
                ingredients.append(ingredient)
            }
        }
        return AnalyzedInstructions.init(name: name, steps: steps, ingredients: ingredients)
    }


}
