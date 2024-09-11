//
//  HistoryItemDataModel.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//

import CoreData

struct HistoryItemDataModel {
    let id: String
    let mealName: String
    let date: Date

    enum InitializationError: Error, LocalizedError {
        case missingRequiredField(String)

        var errorDescription: String? {
            switch self {
            case .missingRequiredField(let fieldName):
                return "Missing required field: \(fieldName)"
            }
        }
    }

    init(from recipe: RecipeDataModel) {
        self.id = recipe.id
        self.mealName = recipe.mealName
        self.date = Date()
    }

    init(from entity: HistoryItemEntity) throws {
        guard let id = entity.id else {
            throw InitializationError.missingRequiredField("id")
        }

        guard let mealName = entity.mealName else {
            throw InitializationError.missingRequiredField("mealName")
        }

        guard let date = entity.date else {
            throw InitializationError.missingRequiredField("date")
        }

        self.id = id
        self.mealName = mealName
        self.date = date
    }

    init(id: String, mealName: String, date: Date) {
        self.id = id
        self.mealName = mealName
        self.date = Date()
    }

    func toEntity(in context: NSManagedObjectContext) -> HistoryItemEntity {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "HistoryItemEntity", in: context) else {
            fatalError("Failed to find entity description for Recipe")
        }
        let entity = HistoryItemEntity(entity: entityDescription, insertInto: context)
        entity.id = id
        entity.mealName = mealName
        entity.date = date
        return entity
    }
}
