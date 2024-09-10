//
//  RecipeRandomInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RecipeRandomInteractorProtocol: RecipeInteractorProtocol {
    func fetchRandomRecipe()
}

class RecipeRandomInteractor: BaseRecipeInteractor, RecipeRandomInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(presenter: RecipePresenterProtocol,
         networkService: NetworkServiceProtocol,
         storageService: StorageServiceProtocol) {
        self.networkService = networkService
        super.init(presenter: presenter, storageService: storageService)
    }
    
    override func fetchRecipe() {
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
                saveRecipe(recipeDataModel)
                saveRecipeToHistory(recipeDataModel)
            } catch {
                AppLogger.shared.error("Failed to fetch random recipe: \(error.localizedDescription)", category: .network)
                presenter.presentError(error)
            }
        }
    }
    
    private func processLoadedRecipe(_ recipe: RecipeDataModel) {
        currentRecipe = recipe
        presenter.presentRecipe(recipe)
    }
    
    private func saveRecipe(_ recipe: RecipeDataModel) {
        do {
            try storageService.saveRecipe(recipe)
            AppLogger.shared.info("Saved last viewed recipe: \(recipe.mealName)", category: .database)
        } catch {
            AppLogger.shared.error("Error saving loaded recipe: \(error.localizedDescription)", category: .database)
        }
    }
    
    private func saveRecipeToHistory(_ recipe: RecipeDataModel) {
        do {
            let historyItem = HistoryItemDataModel(from: recipe)
            try storageService.saveRecipeToHistory(historyItem)
            AppLogger.shared.info("Added recipe to history: \(historyItem.mealName)", category: .database)
        } catch {
            AppLogger.shared.error("Error saving loaded recipe to history: \(error.localizedDescription)", category: .database)
        }
    }
}
