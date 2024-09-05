//
//  StorageService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

enum StorageError: Error, LocalizedError {
    case decodingFailed
    case encodingFailed
    case itemNotFound
    case alreadyInFavorites
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Failed to decode data."
        case .encodingFailed:
            return "Failed to encode data."
        case .itemNotFound:
            return "Item not found."
        case .alreadyInFavorites:
            return "Item is already in favorites."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

protocol StorageServiceProtocol {
    func loadLastViewedRecipe() throws -> StoredRecipe
    func saveLastRecipe(_ recipe: StoredRecipe) throws
    func loadRecipeHistory() throws -> [StoredRecipe]
    func saveRecipeToHistory(_ recipe: StoredRecipe) throws
    func clearHistory() throws
    func loadFavoriteRecipes() throws -> [StoredRecipe]
    func loadFavoriteRecipe(by id: String) throws -> StoredRecipe
    func addRecipeToFavorites(_ recipe: StoredRecipe) throws
    func removeRecipeFromFavorites(_ recipe: StoredRecipe) throws
    func isRecipeFavorite(_ recipe: StoredRecipe) throws -> Bool
}

final class StorageService: StorageServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let recipeKey = "lastRecipe"
    private let recipeHistoryKey = "recipeHistory"
    private let favoritesKey = "favoriteRecipes"
    
    // MARK: - Last Viewed Recipe Methods
    
    func loadLastViewedRecipe() throws -> StoredRecipe {
        guard let data = userDefaults.data(forKey: recipeKey) else {
            AppLogger.shared.error("Last viewed recipe not found", category: .database)
            throw StorageError.itemNotFound
        }
        guard let savedRecipe = try? JSONDecoder().decode(StoredRecipe.self, from: data) else {
            AppLogger.shared.error("Failed to decode last viewed recipe", category: .database)
            throw StorageError.decodingFailed
        }
        AppLogger.shared.info("Loaded last viewed recipe successfully", category: .database)
        return savedRecipe
    }
    
    func saveLastRecipe(_ recipe: StoredRecipe) throws {
        guard let data = try? JSONEncoder().encode(recipe) else {
            AppLogger.shared.error("Failed to encode last recipe", category: .database)
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: recipeKey)
        AppLogger.shared.info("Saved last viewed recipe successfully", category: .database)
    }
    
    // MARK: - Recipe History Methods
    
    func loadRecipeHistory() throws -> [StoredRecipe] {
        guard let data = userDefaults.data(forKey: recipeHistoryKey) else {
            AppLogger.shared.info("Recipe history is empty", category: .database)
            return []
        }
        guard let savedHistory = try? JSONDecoder().decode([StoredRecipe].self, from: data) else {
            AppLogger.shared.error("Failed to decode recipe history", category: .database)
            throw StorageError.decodingFailed
        }
        AppLogger.shared.info("Loaded recipe history successfully", category: .database)
        return savedHistory
    }
    
    func saveRecipeToHistory(_ recipe: StoredRecipe) throws {
        var history = try loadRecipeHistory()
        history.append(recipe)
        guard let data = try? JSONEncoder().encode(history) else {
            AppLogger.shared.error("Failed to encode recipe history", category: .database)
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: recipeHistoryKey)
        AppLogger.shared.info("Saved recipe to history successfully", category: .database)
    }
    
    func clearHistory() throws {
        userDefaults.removeObject(forKey: recipeHistoryKey)
        AppLogger.shared.info("Cleared recipe history", category: .database)
    }
    
    // MARK: - Favorite Recipes Methods
    
    func loadFavoriteRecipes() throws -> [StoredRecipe] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            AppLogger.shared.info("Favorite recipes list is empty", category: .database)
            return []
        }
        guard let savedFavorites = try? JSONDecoder().decode([StoredRecipe].self, from: data) else {
            AppLogger.shared.error("Failed to decode favorite recipes", category: .database)
            throw StorageError.decodingFailed
        }
        AppLogger.shared.info("Loaded favorite recipes successfully", category: .database)
        return savedFavorites
    }
    
    func loadFavoriteRecipe(by id: String) throws -> StoredRecipe {
        let favorites = try loadFavoriteRecipes()
        guard let recipe = favorites.first(where: { $0.id == id }) else {
            AppLogger.shared.error("Favorite recipe with id \(id) not found", category: .database)
            throw StorageError.itemNotFound
        }
        AppLogger.shared.info("Loaded favorite recipe with id \(id) successfully", category: .database)
        return recipe
    }
    
    func addRecipeToFavorites(_ recipe: StoredRecipe) throws {
        var favorites = try loadFavoriteRecipes()
        if favorites.contains(where: { $0.id == recipe.id }) {
            AppLogger.shared.error("Recipe already in favorites", category: .database)
            throw StorageError.alreadyInFavorites
        }
        favorites.append(recipe)
        guard let data = try? JSONEncoder().encode(favorites) else {
            AppLogger.shared.error("Failed to encode favorite recipes", category: .database)
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: favoritesKey)
        AppLogger.shared.info("Added recipe to favorites successfully", category: .database)
    }
    
    func removeRecipeFromFavorites(_ recipe: StoredRecipe) throws {
        var favorites = try loadFavoriteRecipes()
        guard let index = favorites.firstIndex(where: { $0.id == recipe.id }) else {
            AppLogger.shared.error("Recipe not found in favorites", category: .database)
            throw StorageError.itemNotFound
        }
        favorites.remove(at: index)
        guard let data = try? JSONEncoder().encode(favorites) else {
            AppLogger.shared.error("Failed to encode favorite recipes after removal", category: .database)
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: favoritesKey)
        AppLogger.shared.info("Removed recipe from favorites successfully", category: .database)
    }
    
    func isRecipeFavorite(_ recipe: StoredRecipe) throws -> Bool {
        let favorites = try loadFavoriteRecipes()
        let isFavorite = favorites.contains(where: { $0.id == recipe.id })
        AppLogger.shared.info("Checked if recipe is favorite: \(isFavorite)", category: .database)
        return isFavorite
    }
}
