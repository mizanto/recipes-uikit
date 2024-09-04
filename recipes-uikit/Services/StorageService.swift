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
    func loadLastViewedRecipe() throws -> Recipe
    func saveLastRecipe(_ recipe: Recipe) throws
    func loadRecipeHistory() throws -> [Recipe]
    func saveRecipeToHistory(_ recipe: Recipe) throws
    func clearHistory() throws
    func loadFavoriteRecipes() throws -> [Recipe]
    func addRecipeToFavorites(_ recipe: Recipe) throws
    func removeRecipeFromFavorites(_ recipe: Recipe) throws
    func isRecipeFavorite(_ recipe: Recipe) throws -> Bool
}

final class StorageService: StorageServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let recipeKey = "lastRecipe"
    private let recipeHistoryKey = "recipeHistory"
    private let favoritesKey = "favoriteRecipes"
    
    // MARK: - Last Viewed Recipe Methods
    
    func loadLastViewedRecipe() throws -> Recipe {
        guard let data = userDefaults.data(forKey: recipeKey) else {
            throw StorageError.itemNotFound
        }
        guard let savedRecipe = try? JSONDecoder().decode(Recipe.self, from: data) else {
            throw StorageError.decodingFailed
        }
        return savedRecipe
    }
    
    func saveLastRecipe(_ recipe: Recipe) throws {
        guard let data = try? JSONEncoder().encode(recipe) else {
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: recipeKey)
    }
    
    // MARK: - Recipe History Methods
    
    func loadRecipeHistory() throws -> [Recipe] {
        guard let data = userDefaults.data(forKey: recipeHistoryKey) else {
            return []
        }
        guard let savedHistory = try? JSONDecoder().decode([Recipe].self, from: data) else {
            throw StorageError.decodingFailed
        }
        return savedHistory
    }
    
    func saveRecipeToHistory(_ recipe: Recipe) throws {
        var history = try loadRecipeHistory()
        history.append(recipe)
        guard let data = try? JSONEncoder().encode(history) else {
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: recipeHistoryKey)
    }
    
    func clearHistory() throws {
        userDefaults.removeObject(forKey: recipeHistoryKey)
    }
    
    // MARK: - Favorite Recipes Methods
    
    func loadFavoriteRecipes() throws -> [Recipe] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }
        guard let savedFavorites = try? JSONDecoder().decode([Recipe].self, from: data) else {
            throw StorageError.decodingFailed
        }
        return savedFavorites
    }
    
    func addRecipeToFavorites(_ recipe: Recipe) throws {
        var favorites = try loadFavoriteRecipes()
        if favorites.contains(where: { $0.id == recipe.id }) {
            throw StorageError.alreadyInFavorites
        }
        favorites.append(recipe)
        guard let data = try? JSONEncoder().encode(favorites) else {
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: favoritesKey)
    }
    
    func removeRecipeFromFavorites(_ recipe: Recipe) throws {
        var favorites = try loadFavoriteRecipes()
        guard let index = favorites.firstIndex(where: { $0.id == recipe.id }) else {
            throw StorageError.itemNotFound
        }
        favorites.remove(at: index)
        guard let data = try? JSONEncoder().encode(favorites) else {
            throw StorageError.encodingFailed
        }
        userDefaults.set(data, forKey: favoritesKey)
    }
    
    func isRecipeFavorite(_ recipe: Recipe) throws -> Bool {
        let favorites = try loadFavoriteRecipes()
        return favorites.contains(where: { $0.id == recipe.id })
    }
}
