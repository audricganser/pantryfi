//
//  Diet.swift
//  PantryFi
//
//  Created by Audric Ganser on 5/3/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Diet {
    var diet:String
    var dietSwitch:Bool
    let ref: FIRDatabaseReference?
    
    init(diet:String, dietSwitch:Bool = false )
    {
        self.diet       = diet
        self.dietSwitch = dietSwitch
        self.ref        = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        diet       = snapshotValue["diet"] as! String
        dietSwitch = snapshotValue["dietSwitch"] as! Bool
        ref        = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "diet"           : diet,
            "dietSwitch"     : dietSwitch,
        ]
    }
}
