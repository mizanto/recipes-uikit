//
//  RecipeEntity+CoreDataProperties.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//
//

import Foundation
import CoreData

extension RecipeEntity {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var mealName: String?
    @NSManaged public var category: String?
    @NSManaged public var area: String?
    @NSManaged public var instructions: String?
    @NSManaged public var mealThumbURL: String?
    @NSManaged public var youtubeURL: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var ingredients: [IngredientEntity]?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isFavorite: Bool

}

extension RecipeEntity: Identifiable {}
