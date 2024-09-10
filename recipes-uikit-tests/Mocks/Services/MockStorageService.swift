//
//  MockStorageService.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 9.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockStorageService: StorageServiceProtocol {
    var recipes: [RecipeDataModel] = []
    var history: [HistoryItemDataModel] = []
    var error: StorageServiceError?
    
    private var favoriteRecipes: [RecipeDataModel] {
        recipes.filter { $0.isFavorite }
    }
    
    private func throwErrorIfNeeded() throws {
        if let error = error {
            throw error
        }
    }
    
    func getLastRecipe() throws -> RecipeDataModel {
        try throwErrorIfNeeded()
        
        guard let recipe = recipes.last else {
            throw StorageServiceError.itemNotFound
        }
        return recipe
    }
    
    func getRecipe(by id: String) throws -> RecipeDataModel {
        try throwErrorIfNeeded()
        
        guard let recipe = recipes.first(where: { $0.id == id }) else {
            throw StorageServiceError.itemNotFound
        }
        return recipe
    }
    
    func saveRecipe(_ recipe: RecipeDataModel) throws {
        try throwErrorIfNeeded()
        recipes.append(recipe)
    }
    
    func getRecipeHistory() throws -> [HistoryItemDataModel] {
        try throwErrorIfNeeded()
        
        guard !history.isEmpty else {
            throw StorageServiceError.itemNotFound
        }
        return history
    }
    
    func saveRecipeToHistory(_ recipe: HistoryItemDataModel) throws {
        try throwErrorIfNeeded()
        history.append(recipe)
    }
    
    func clearHistory() throws {
        try throwErrorIfNeeded()
        history = []
    }
    
    func getFavoriteRecipes() throws -> [RecipeDataModel] {
        try throwErrorIfNeeded()
        return favoriteRecipes
    }
    
    func addRecipeToFavorites(_ recipe: RecipeDataModel) throws {
        try throwErrorIfNeeded()
        
        guard !favoriteRecipes.contains(where: { $0.id == recipe.id }) else {
            throw StorageServiceError.alreadyInFavorites
        }
        
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else {
            throw StorageServiceError.itemNotFound
        }
        
        recipes[index].isFavorite = true
    }
    
    func removeRecipeFromFavorites(_ recipe: RecipeDataModel) throws {
        try throwErrorIfNeeded()
        
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else {
            throw StorageServiceError.itemNotFound
        }
        
        recipes[index].isFavorite = false
    }
    
    func isRecipeFavorite(_ recipe: RecipeDataModel) throws -> Bool {
        try throwErrorIfNeeded()
        return favoriteRecipes.contains(where: { $0.id == recipe.id })
    }
}
