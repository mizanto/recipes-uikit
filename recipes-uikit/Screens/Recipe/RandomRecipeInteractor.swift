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
    
    private var currentRecipe: StoredRecipe?
    private var isFavorite: Bool = false
    
    init(presenter: RecipePresenterProtocol,
         networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.presenter = presenter
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchRecipe() {
        if let recipe = currentRecipe {
            AppLogger.shared.info("Using cached recipe: \(recipe.mealName)", category: .network)
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
            return
        }

        if let recipe = try? storageService.loadLastViewedRecipe() {
            AppLogger.shared.info("Loaded recipe from storage: \(recipe.mealName)", category: .database)
            processLoadedRecipe(recipe)
            return
        }
        
        fetchRandomRecipeFromNetwork()
    }
    
    func fetchRandomRecipe() {
        fetchRandomRecipeFromNetwork()
    }

    private func fetchRandomRecipeFromNetwork() {
        AppLogger.shared.info("Fetching random recipe from network...", category: .network)
        Task {
            do {
                let recipeDTO = try await networkService.fetchRandomRecipe()
                let storedRecipe = StoredRecipe(from: recipeDTO)
                AppLogger.shared.info("Fetched random recipe: \(storedRecipe.mealName) from network", category: .network)
                processLoadedRecipe(storedRecipe)
            } catch {
                AppLogger.shared.error("Failed to fetch random recipe: \(error.localizedDescription)", category: .network)
                presenter.presentError(error)
            }
        }
    }
    
    private func processLoadedRecipe(_ recipe: StoredRecipe) {
        currentRecipe = recipe
        
        do {
            try storageService.saveLastRecipe(recipe)
            AppLogger.shared.info("Saved last viewed recipe: \(recipe.mealName)", category: .database)
            try storageService.saveRecipeToHistory(recipe)
            AppLogger.shared.info("Added recipe to history: \(recipe.mealName)", category: .database)
            
            isFavorite = try storageService.isRecipeFavorite(recipe)
            
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            AppLogger.shared.error("Error processing loaded recipe: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
    
    func toggleFavoriteStatus() {
        guard let recipe = currentRecipe else {
            AppLogger.shared.error("No recipe available to toggle favorite status", category: .ui)
            presenter.presentError(StorageError.itemNotFound)
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
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            AppLogger.shared.error("Failed to toggle favorite status: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
}
