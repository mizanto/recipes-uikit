//
//  StorageService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func loadLastViewedRecipe() -> Recipe?
    func saveLastRecipe(_ recipe: Recipe)
    func loadRecipeHistory() -> [Recipe]
    func saveRecipeToHistory(_ recipe: Recipe)
    func clearHistory()
}

final class StorageService: StorageServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let recipeKey = "lastRecipe"
    private let recipeHistoryKey = "recipeHistory"
    
    func loadLastViewedRecipe() -> Recipe? {
        if let data = userDefaults.data(forKey: recipeKey),
           let savedRecipe = try? JSONDecoder().decode(Recipe.self, from: data) {
            return savedRecipe
        } else {
            return nil
        }
    }
    
    func saveLastRecipe(_ recipe: Recipe) {
        if let data = try? JSONEncoder().encode(recipe) {
            userDefaults.set(data, forKey: recipeKey)
        }
    }
    
    func loadRecipeHistory() -> [Recipe] {
        if let data = userDefaults.data(forKey: recipeHistoryKey),
           let savedHistory = try? JSONDecoder().decode([Recipe].self, from: data) {
            return savedHistory
        }
        return []
    }
    
    func saveRecipeToHistory(_ recipe: Recipe) {
        var history = loadRecipeHistory()
        history.append(recipe)
        if let data = try? JSONEncoder().encode(history) {
            userDefaults.set(data, forKey: recipeHistoryKey)
        }
    }
    
    func clearHistory() {
        userDefaults.removeObject(forKey: recipeHistoryKey)
    }
}
