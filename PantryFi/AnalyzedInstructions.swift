//
//  AnalyzedInstructions.swift
//  PantryFi
//
//  Created by david ares on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation

class AnalyzedInstructions  {
    var name:String
    var steps:[Steps]
    var ingredients:[Ingredient]
    
    init(name:String = "", steps:[Steps] = [], ingredients: [Ingredient] = []) {
        self.name = name
        self.steps = steps
        self.ingredients = ingredients
    }
}

