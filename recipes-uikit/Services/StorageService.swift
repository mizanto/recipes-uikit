//
//  StorageService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import CoreData

// MARK: - Custom Error for Core Data Operations

enum StorageServiceError: Error, LocalizedError {
    case itemNotFound
    case failedToFetch
    case failedToSave
    case failedToDelete
    case alreadyInFavorites
    case unknown

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found."
        case .failedToFetch:
            return "Failed to fetch items."
        case .failedToSave:
            return "Failed to save item."
        case .failedToDelete:
            return "Failed to delete item."
        case .alreadyInFavorites:
            return "Item is already in favorites."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - Storage Service Protocol

protocol StorageServiceProtocol {
    func getLastRecipe() throws -> RecipeDataModel
    func getRecipe(by id: String) throws -> RecipeDataModel
    func saveRecipe(_ recipe: RecipeDataModel) throws
    func getRecipeHistory() throws -> [HistoryItemDataModel]
    func saveRecipeToHistory(_ recipe: HistoryItemDataModel) throws
    func clearHistory() throws
    func getFavoriteRecipes() throws -> [RecipeDataModel]
    func addRecipeToFavorites(_ recipe: RecipeDataModel) throws
    func removeRecipeFromFavorites(_ recipe: RecipeDataModel) throws
    func isRecipeFavorite(_ recipe: RecipeDataModel) throws -> Bool
}

// MARK: - Storage Service Implementation

final class StorageService: StorageServiceProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // MARK: - Last Viewed Recipe Methods

    func getLastRecipe() throws -> RecipeDataModel {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        request.fetchLimit = 1

        do {
            guard let entity = try context.fetch(request).first else {
                AppLogger.shared.error("Last viewed recipe not found", category: .database)
                throw StorageServiceError.itemNotFound
            }
            let recipeDataModel = try RecipeDataModel(from: entity)
            AppLogger.shared.info("Loaded last viewed recipe successfully", category: .database)
            return recipeDataModel
        } catch let error as RecipeDataModel.InitializationError {
            AppLogger.shared.error("Initialization error: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToFetch
        } catch {
            AppLogger.shared.error("Failed to fetch last viewed recipe: \(error.localizedDescription)",
                                   category: .database)
            throw StorageServiceError.failedToFetch
        }
    }

    func getRecipe(by id: String) throws -> RecipeDataModel {
        guard let entity = try fetchRecipeEntity(by: id) else {
            AppLogger.shared.error("Recipe with id \(id) not found", category: .database)
            throw StorageServiceError.itemNotFound
        }

        do {
            let recipeDataModel = try RecipeDataModel(from: entity)
            AppLogger.shared.info("Loaded recipe with id \(id) successfully", category: .database)
            return recipeDataModel
        } catch let error as RecipeDataModel.InitializationError {
            AppLogger.shared.error("Initialization error: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToFetch
        }
    }

    func saveRecipe(_ recipe: RecipeDataModel) throws {
        _ = recipe.toEntity(in: context)
        do {
            try context.save()
            AppLogger.shared.info("Saved recipe \(recipe.mealName) successfully", category: .database)
        } catch {
            AppLogger.shared.error("Failed to save last recipe: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToSave
        }
    }

    // MARK: - Recipe History Methods

    func getRecipeHistory() throws -> [HistoryItemDataModel] {
        let request: NSFetchRequest<HistoryItemEntity> = HistoryItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let entities = try context.fetch(request)
            let history = try entities.map { try HistoryItemDataModel(from: $0) }
            AppLogger.shared.info("Loaded recipe history successfully", category: .database)
            return history
        } catch let error as HistoryItemDataModel.InitializationError {
            AppLogger.shared.error("Initialization error: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToFetch
        } catch {
            AppLogger.shared.error("Failed to fetch recipe history: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToFetch
        }
    }

    func saveRecipeToHistory(_ recipe: HistoryItemDataModel) throws {
        _ = recipe.toEntity(in: context)
        do {
            try context.save()
            AppLogger.shared.info("Saved recipe to history successfully", category: .database)
        } catch {
            AppLogger.shared.error("Failed to save recipe to history: \(error.localizedDescription)",
                                   category: .database)
            throw StorageServiceError.failedToSave
        }
    }

    func clearHistory() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = HistoryItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try context.save()
            AppLogger.shared.info("Cleared recipe history", category: .database)
        } catch {
            AppLogger.shared.error("Failed to clear recipe history: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToDelete
        }
    }

    // MARK: - Favorite Recipes Methods

    func getFavoriteRecipes() throws -> [RecipeDataModel] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")

        do {
            let entities = try context.fetch(request)
            let favorites = try entities.map { try RecipeDataModel(from: $0) }
            AppLogger.shared.info("Loaded favorite recipes successfully", category: .database)
            return favorites
        } catch let error as RecipeDataModel.InitializationError {
            AppLogger.shared.error("Initialization error: \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToFetch
        } catch {
            AppLogger.shared.error("Failed to fetch favorite recipes: \(error.localizedDescription)",
                                   category: .database)
            throw StorageServiceError.failedToFetch
        }
    }

    func addRecipeToFavorites(_ recipe: RecipeDataModel) throws {
        try updateRecipeFavoriteStatus(recipe, shouldBeFavorite: true)
    }

    func removeRecipeFromFavorites(_ recipe: RecipeDataModel) throws {
        try updateRecipeFavoriteStatus(recipe, shouldBeFavorite: false)
    }

    func isRecipeFavorite(_ recipe: RecipeDataModel) throws -> Bool {
        guard let entity = try fetchRecipeEntity(by: recipe.id) else {
            AppLogger.shared.error("Recipe with id \(recipe.id) not found", category: .database)
            throw StorageServiceError.itemNotFound
        }
        let isFavorite = entity.isFavorite
        AppLogger.shared.info("Checked if recipe is favorite: \(isFavorite)", category: .database)
        return isFavorite
    }

    // MARK: - Helper Methods

    private func fetchRecipeEntity(by id: String) throws -> RecipeEntity? {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try context.fetch(request).first
    }

    private func updateRecipeFavoriteStatus(_ recipe: RecipeDataModel, shouldBeFavorite: Bool) throws {
        guard let entity = try fetchRecipeEntity(by: recipe.id) else {
            AppLogger.shared.error("Recipe with id \(recipe.id) not found", category: .database)
            throw StorageServiceError.itemNotFound
        }

        if shouldBeFavorite && entity.isFavorite {
            AppLogger.shared.error("Recipe already in favorites", category: .database)
            throw StorageServiceError.alreadyInFavorites
        } else if !shouldBeFavorite && !entity.isFavorite {
            AppLogger.shared.error("Recipe not found in favorites", category: .database)
            throw StorageServiceError.itemNotFound
        }

        entity.isFavorite = shouldBeFavorite
        do {
            try context.save()
            if shouldBeFavorite {
                AppLogger.shared.info("Added recipe to favorites successfully", category: .database)
            } else {
                AppLogger.shared.info("Removed recipe from favorites successfully", category: .database)
            }
        } catch {
            let action = shouldBeFavorite ? "add recipe to favorites" : "remove recipe from favorites"
            AppLogger.shared.error("Failed to \(action): \(error.localizedDescription)", category: .database)
            throw StorageServiceError.failedToSave
        }
    }
}
