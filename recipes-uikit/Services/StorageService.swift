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
}

final class StorageService: StorageServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let recipeKey = "lastRecipe"
    
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
}
