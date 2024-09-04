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
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
            return
        }

        if let recipe = try? storageService.loadLastViewedRecipe() {
            processLoadedRecipe(recipe)
            return
        }
        
        fetchRandomRecipeFromNetwork()
    }
    
    func fetchRandomRecipe() {
        fetchRandomRecipeFromNetwork()
    }

    private func fetchRandomRecipeFromNetwork() {
        Task {
            do {
                let recipeDTO = try await networkService.fetchRandomRecipe()
                let storedRecipe = StoredRecipe(from: recipeDTO)
                processLoadedRecipe(storedRecipe)
            } catch {
                presenter.presentError(error)
            }
        }
    }
    
    private func processLoadedRecipe(_ recipe: StoredRecipe) {
        currentRecipe = recipe
        
        do {
            try storageService.saveLastRecipe(recipe)
            try storageService.saveRecipeToHistory(recipe)
            
            isFavorite = try storageService.isRecipeFavorite(recipe)
            
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            presenter.presentError(error)
        }
    }
    
    func toggleFavoriteStatus() {
        guard let recipe = currentRecipe else {
            presenter.presentError(StorageError.itemNotFound)
            return
        }
        
        do {
            if isFavorite {
                try storageService.removeRecipeFromFavorites(recipe)
                isFavorite = false
            } else {
                try storageService.addRecipeToFavorites(recipe)
                isFavorite = true
            }
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
        } catch {
            presenter.presentError(error)
        }
    }
}
