//
//  RandomRecipeInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RandomRecipeInteractorProtocol: AnyObject {
    func fetchRandomRecipe()
    func saveRecipeToFavorites()
    func saveLastViewedRecipe()
    func loadLastViewedRecipe()
}

class RandomRecipeInteractor: RandomRecipeInteractorProtocol {
    
    private let presenter: RandomRecipePresenterProtocol
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    private var currentRecipe: Recipe?
    
    init(presenter: RandomRecipePresenterProtocol,
         networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.presenter = presenter
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchRandomRecipe() {
        Task {
            do {
                let recipe = try await networkService.fetchRandomRecipe()
                presenter.presentRecipe(recipe)
                currentRecipe = recipe
                saveLastViewedRecipe()
            } catch {
                presenter.presentError(error)
            }
        }
    }
    
    func saveRecipeToFavorites() {
        if let recipe = currentRecipe {
            // TODO: add logic for Favorites
            print("Info: Recipe '\(recipe.mealName)' was saved to favorites.")
        } else {
            print("Error: Failed to save. Current recipe is nil.")
        }
    }
    
    func saveLastViewedRecipe() {
        if let recipe = currentRecipe {
            storageService.saveLastRecipe(recipe)
            print("Info: Recipe '\(recipe)' was saved to favorites.")
        } else {
            print("Error: Failed to save. Current recipe is nil.")
        }
    }
    
    func loadLastViewedRecipe() {
        if let recipe = storageService.loadLastViewedRecipe() {
            presenter.presentRecipe(recipe)
            currentRecipe = recipe
        }
    }
}
