//
//  allergies.swift
//  PantryFi
//
//  Created by Audric Ganser on 5/2/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Allergies {
    
    var name:String
    let ref: FIRDatabaseReference?
    let key: String
    
    
    init(name:String, key: String = "")
    {
        self.key = key
        self.name = name
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
        ]
    }
}
