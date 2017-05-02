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
    var unit:String
    var expirationDate:String
    var expirationAlert:Bool
    let ref: FIRDatabaseReference?
    let key: String
    let image:String

    
    init(name:String, quantity:String, key: String = "", image:String = "")
    {
        self.key = key
        self.name = name
        self.quantity = quantity
        self.ref = nil
        self.image = image
        self.unit = ""
        self.expirationAlert = false
        self.expirationDate = ""
    }
    
    init(name:String, quantity:String, key: String = "", unit:String, expirationDate:String, expirationAlert:Bool, image:String = "")
    {
        self.key = key
        self.name = name
        self.quantity = quantity
        self.ref = nil
        self.unit = unit
        self.expirationDate = expirationDate
        self.expirationAlert = expirationAlert
        self.image = image
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        quantity = snapshotValue["quantity"] as! String
        unit = snapshotValue["unit"] as! String
        expirationDate = snapshotValue["expirationDate"] as! String
        expirationAlert = snapshotValue["expirationAlert"] as! Bool
        ref = snapshot.ref
        image = snapshotValue["image"] as! String
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "quantity": quantity,
            "unit": unit,
            "expirationDate": expirationDate,
            "expirationAlert": expirationAlert,
            "image": image
        ]
    }
}
