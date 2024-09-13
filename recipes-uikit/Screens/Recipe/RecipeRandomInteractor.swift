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
                AppLogger.shared.info("Fetched random recipe: \(recipeNetworkModel.mealName) from network", category: .network)
                
                try await handleFetchedRecipe(recipeNetworkModel)
            } catch let networkError as NetworkError {
                AppLogger.shared.error("Network error while fetching random recipe: \(networkError.localizedDescription)", category: .network)
                presenter.presentError(networkError)
            } catch let storageError as StorageError {
                AppLogger.shared.error("Storage error while handling recipe: \(storageError.localizedDescription)", category: .database)
                presenter.presentError(storageError)
            } catch {
                AppLogger.shared.error("Unexpected error while fetching random recipe: \(error.localizedDescription)", category: .network)
                presenter.presentError(error)
            }
        }
    }

    private func handleFetchedRecipe(_ recipeNetworkModel: RecipeNetworkModel) async throws {
        if let recipe = try? storageService.getRecipe(by: recipeNetworkModel.id) {
            AppLogger.shared.info("Present recipe: \(recipe.mealName) from storage", category: .database)
            processLoadedRecipe(recipe)
        } else {
            let recipe = RecipeDataModel(from: recipeNetworkModel)
            AppLogger.shared.info("Present recipe: \(recipe.mealName) from network", category: .network)
            processLoadedRecipe(recipe)
            try saveRecipeIfNotExists(recipe)
        }
        saveRecipeToHistory(id: recipeNetworkModel.id, mealName: recipeNetworkModel.mealName)
    }

    private func processLoadedRecipe(_ recipe: RecipeDataModel) {
        currentRecipe = recipe
        presentRecipe(recipe)
    }

    private func saveRecipeIfNotExists(_ recipe: RecipeDataModel) throws {
        do {
            try storageService.saveRecipe(recipe)
            AppLogger.shared.info("Saved last viewed recipe: \(recipe.mealName)", category: .database)
        } catch {
            AppLogger.shared.error("Error saving loaded recipe: \(error.localizedDescription)", category: .database)
            throw StorageError.failedToSave
        }
    }

    private func saveRecipeToHistory(id: String, mealName: String) {
        do {
            let historyItem = HistoryItemDataModel(id: id, mealName: mealName)
            try storageService.saveRecipeToHistory(historyItem)
            AppLogger.shared.info("Added recipe to history: \(historyItem.mealName)", category: .database)
        } catch {
            AppLogger.shared.error("Error saving loaded recipe to history: \(error.localizedDescription)", category: .database)
        }
    }
}
