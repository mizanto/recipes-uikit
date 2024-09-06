//
//  RecipeDetailInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol RecipeInteractorProtocol: AnyObject {
    func fetchRecipe()
    func toggleFavoriteStatus()
}

class RecipeDetailInteractor: RecipeInteractorProtocol {
    private let presenter: RecipePresenterProtocol
    private let storageService: StorageServiceProtocol
    private let recipeId: String
    
    private var currentRecipe: RecipeDataModel?
    private var isFavorite: Bool = false
    
    init(presenter: RecipePresenterProtocol,
         storageService: StorageServiceProtocol,
         recipeId: String) {
        self.presenter = presenter
        self.storageService = storageService
        self.recipeId = recipeId
    }
    
    func fetchRecipe() {
        AppLogger.shared.info("Fetching recipe with ID: \(recipeId)", category: .database)
        do {
            let recipe = try storageService.getFavoriteRecipe(by: recipeId)
            currentRecipe = recipe
            AppLogger.shared.info("Loaded recipe from favorites: \(recipe.mealName)", category: .database)
            
            isFavorite = recipe.isFavorite
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            AppLogger.shared.error("Failed to fetch recipe: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
    
    func toggleFavoriteStatus() {
        guard let recipe = currentRecipe else {
            AppLogger.shared.error("No recipe available to toggle favorite status", category: .ui)
            presenter.presentError(StorageServiceError.itemNotFound)
            return
        }
        
        do {
            if isFavorite {
                try storageService.removeRecipeFromFavorites(recipe)
                isFavorite = false
                AppLogger.shared.info("Removed recipe from favorites: \(recipe.mealName)", category: .database)
            } else {
                try storageService.addRecipeToFavorites(recipe)
                isFavorite = true
                AppLogger.shared.info("Added recipe to favorites: \(recipe.mealName)", category: .database)
            }
            currentRecipe?.isFavorite = isFavorite
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            AppLogger.shared.error("Failed to toggle favorite status: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
}
