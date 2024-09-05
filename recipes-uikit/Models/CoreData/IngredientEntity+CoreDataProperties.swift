//
//  IngredientEntity+CoreDataProperties.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//
//

import Foundation
import CoreData


extension IngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientEntity> {
        return NSFetchRequest<IngredientEntity>(entityName: "IngredientEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var measure: String?

}

extension IngredientEntity : Identifiable {

}
