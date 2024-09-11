//
//  RecipeDataModel.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import CoreData

struct RecipeDataModel {
    let id: String
    let mealName: String
    let category: String?
    let area: String?
    let instructions: String
    let mealThumbURL: URL
    let youtubeURL: URL?
    let sourceURL: URL?
    let ingredients: [Ingredient]
    let dateAdded: Date
    var isFavorite: Bool

    enum InitializationError: Error, LocalizedError {
        case missingRequiredField(String)

        var errorDescription: String? {
            switch self {
            case .missingRequiredField(let fieldName):
                return "Missing required field: \(fieldName)"
            }
        }
    }

    init(from networkModel: RecipeNetworkModel) {
        self.id = networkModel.id
        self.mealName = networkModel.mealName
        self.category = networkModel.category
        self.area = networkModel.area
        self.instructions = networkModel.instructions
        self.mealThumbURL = networkModel.mealThumbURL
        self.youtubeURL = networkModel.youtubeURL
        self.sourceURL = networkModel.sourceURL
        self.ingredients = networkModel.ingredients
        self.dateAdded = Date()
        self.isFavorite = false
    }

    init(from entity: RecipeEntity) throws {
        // Validate required fields
        guard let id = entity.id else {
            throw InitializationError.missingRequiredField("id")
        }

        guard let mealName = entity.mealName else {
            throw InitializationError.missingRequiredField("mealName")
        }

        guard let instructions = entity.instructions else {
            throw InitializationError.missingRequiredField("instructions")
        }

        guard let mealThumbURLString = entity.mealThumbURL, let mealThumbURL = URL(string: mealThumbURLString) else {
            throw InitializationError.missingRequiredField("mealThumbURL")
        }

        guard let ingredientEntities = entity.ingredients else {
            throw InitializationError.missingRequiredField("ingredients")
        }

        guard let dateAdded = entity.dateAdded else {
            throw InitializationError.missingRequiredField("dateAdded")
        }

        // Convert IngredientEntity to Ingredient
        let ingredients = ingredientEntities.compactMap { entity -> Ingredient? in
            guard let name = entity.name, let measure = entity.measure else {
                return nil
            }
            return Ingredient(name: name, measure: measure)
        }

        // Initialize properties
        self.id = id
        self.mealName = mealName
        self.category = entity.category
        self.area = entity.area
        self.instructions = instructions
        self.mealThumbURL = mealThumbURL
        self.youtubeURL = entity.youtubeURL.flatMap(URL.init)
        self.sourceURL = entity.sourceURL.flatMap(URL.init)
        self.ingredients = ingredients
        self.dateAdded = dateAdded
        self.isFavorite = entity.isFavorite
    }

    init(id: String,
         mealName: String,
         category: String? = nil,
         area: String? = nil,
         instructions: String,
         mealThumbURL: URL,
         youtubeURL: URL? = nil,
         sourceURL: URL? = nil,
         ingredients: [Ingredient],
         dateAdded: Date,
         isFavorite: Bool = false) {
        self.id = id
        self.mealName = mealName
        self.category = category
        self.area = area
        self.instructions = instructions
        self.mealThumbURL = mealThumbURL
        self.youtubeURL = youtubeURL
        self.sourceURL = sourceURL
        self.ingredients = ingredients
        self.dateAdded = dateAdded
        self.isFavorite = isFavorite
    }

    func toEntity(in context: NSManagedObjectContext) -> RecipeEntity {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: context) else {
            fatalError("Failed to find entity description for Recipe")
        }
        let entity = RecipeEntity(entity: entityDescription, insertInto: context)
        entity.id = id
        entity.mealName = mealName
        entity.category = category
        entity.area = area
        entity.instructions = instructions
        entity.mealThumbURL = mealThumbURL.absoluteString
        entity.youtubeURL = youtubeURL?.absoluteString
        entity.sourceURL = sourceURL?.absoluteString
        entity.ingredients = ingredients.map { ingredient in
            let ingredientEntity = IngredientEntity(context: context)
            ingredientEntity.name = ingredient.name
            ingredientEntity.measure = ingredient.measure
            return ingredientEntity
        }
        entity.dateAdded = dateAdded
        entity.isFavorite = isFavorite
        return entity
    }
}
