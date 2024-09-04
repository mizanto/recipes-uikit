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
                
                try storageService.saveLastRecipe(recipe)
                try storageService.saveRecipeToHistory(recipe)
                
            } catch {
                presenter.presentError(error)
            }
        }
    }
    
    func saveRecipeToFavorites() {
        guard let recipe = currentRecipe else {
            presenter.presentError(StorageError.itemNotFound)
            return
        }
        
        do {
            try storageService.addRecipeToFavorites(recipe)
            print("Info: Recipe '\(recipe.mealName)' was saved to favorites.")
        } catch {
            presenter.presentError(error)
        }
    }
    
    func loadLastViewedRecipe() {
        do {
            let recipe = try storageService.loadLastViewedRecipe()
            presenter.presentRecipe(recipe)
            currentRecipe = recipe
        } catch {
            presenter.presentError(error)
        }
    }
}
