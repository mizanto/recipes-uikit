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
    
    private var currentRecipe: StoredRecipe?
    private var isFavorite: Bool = false
    
    init(presenter: RecipePresenterProtocol,
         storageService: StorageServiceProtocol = StorageService(),
         recipeId: String) {
        self.presenter = presenter
        self.storageService = storageService
        self.recipeId = recipeId
    }
    
    func fetchRecipe() {
        do {
            let recipe = try storageService.loadFavoriteRecipe(by: recipeId)
            currentRecipe = recipe
            
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
