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
    
    init(name:String = "", steps:[Steps] = []) {
        self.name = name
        self.steps = steps
    }
}

