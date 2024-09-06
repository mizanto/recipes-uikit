//
//  RandomRecipeInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RandomRecipeInteractorProtocol: RecipeInteractorProtocol {
    func fetchRandomRecipe()
}

class RandomRecipeInteractor: RandomRecipeInteractorProtocol {
    
    private let presenter: RecipePresenterProtocol
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    private var currentRecipe: RecipeDataModel?
    private var isFavorite: Bool = false
    
    init(presenter: RecipePresenterProtocol,
         networkService: NetworkServiceProtocol,
         storageService: StorageServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchRecipe() {
        do {
            let recipe = try storageService.getLastRecipe()
            AppLogger.shared.info("Loaded recipe from storage: \(recipe.mealName)", category: .database)
            processLoadedRecipe(recipe)
        } catch {
            AppLogger.shared.error("Failed to load last viewed recipe: \(error.localizedDescription)", category: .database)
            fetchRandomRecipeFromNetwork()
        }
    }
    
    func fetchRandomRecipe() {
        fetchRandomRecipeFromNetwork()
    }

    private func fetchRandomRecipeFromNetwork() {
        AppLogger.shared.info("Fetching random recipe from network...", category: .network)
        Task {
            do {
                let recipeNetworkModel = try await networkService.fetchRandomRecipe()
                let recipeDataModel = RecipeDataModel(from: recipeNetworkModel)
                AppLogger.shared.info("Fetched random recipe: \(recipeDataModel.mealName) from network", category: .network)
                processLoadedRecipe(recipeDataModel)
                saveRecipeToHistory(recipeDataModel)
            } catch {
                AppLogger.shared.error("Failed to fetch random recipe: \(error.localizedDescription)", category: .network)
                presenter.presentError(error)
            }
        }
    }
    
    private func processLoadedRecipe(_ recipe: RecipeDataModel) {
        currentRecipe = recipe
        
        do {
            try storageService.saveRecipe(recipe)
            AppLogger.shared.info("Saved last viewed recipe: \(recipe.mealName)", category: .database)
            
            isFavorite = recipe.isFavorite
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            AppLogger.shared.error("Error processing loaded recipe: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
    
    private func saveRecipeToHistory(_ recipe: RecipeDataModel) {
        do {
            let historyItem = HistoryItemDataModel(from: recipe)
            try storageService.saveRecipeToHistory(historyItem)
            AppLogger.shared.info("Added recipe to history: \(historyItem.mealName)", category: .database)
        } catch {
            AppLogger.shared.error("Error saving loaded recipe: \(error.localizedDescription)", category: .database)
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
