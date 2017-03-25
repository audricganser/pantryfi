//
//  Ingredient+CoreDataProperties.swift
//  PantryFi
//
//  Created by Audric Ganser on 3/23/17.
//  Copyright © 2017 IOS Group 5. All rights reserved.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient");
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?

}
