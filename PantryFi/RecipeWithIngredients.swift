//
//  RecipeWithIngredients.swift
//  PantryFi
//
//  Created by david ares on 4/16/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation

class RecipeWithIngredients {
    var id:String
    var title:String
    var image:String
    var usedIngredientCount:Int
    var missedIngredientCount:Int
    var likes:Int
    
    
    init(id:String, title:String, image:String, usedIngredientCount:Int, missedIngredientCount:Int, likes:Int) {
        self.id = id
        self.title = title
        self.image = image
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        self.likes = likes
    }
    

}
