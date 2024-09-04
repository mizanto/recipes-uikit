//
//  RandomRecipeInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RandomRecipeInteractorProtocol: AnyObject {
    func fetchRandomRecipe()
    func toggleFavoriteStatus()
    func loadLastViewedRecipe()
}

class RandomRecipeInteractor: RandomRecipeInteractorProtocol {
    
    private let presenter: RandomRecipePresenterProtocol
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    private var currentRecipe: Recipe?
    private var isFavorite: Bool = false
    
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
                currentRecipe = recipe
                
                try storageService.saveLastRecipe(recipe)
                try storageService.saveRecipeToHistory(recipe)
                
                isFavorite = try storageService.isRecipeFavorite(recipe)
                presenter.presentRecipe(recipe, isFavorite: isFavorite)
                
            } catch {
                presenter.presentError(error)
            }
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
    
    func loadLastViewedRecipe() {
        do {
            let recipe = try storageService.loadLastViewedRecipe()
            currentRecipe = recipe
            
            isFavorite = try storageService.isRecipeFavorite(recipe)
            presenter.presentRecipe(recipe, isFavorite: isFavorite)
            
        } catch {
            presenter.presentError(error)
        }
    }
}
