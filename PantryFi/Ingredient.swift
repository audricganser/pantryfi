//
//  Ingredient.swift
//  PantryFi
//
//  Created by RAZA on 4/16/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Ingredient {
    
    var name:String
    var quantity:String
    let ref: FIRDatabaseReference?
    let key: String

    
    init(name:String, quantity:String, key: String = "")
    {
        self.key = key
        self.name = name
        self.quantity = quantity
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        quantity = snapshotValue["quantity"] as! String
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "quantity": quantity,
        ]
    }
}
