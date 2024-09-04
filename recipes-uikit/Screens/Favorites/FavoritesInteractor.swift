//
//  FavoritesInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesInteractorProtocol {
    func fetchFavoriteRecipes()
    func removeRecipeFromFavorites(_ recipe: Recipe)
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    
    private let presenter: FavoritesPresenterProtocol
    private let storageService: StorageServiceProtocol
    
    init(presenter: FavoritesPresenterProtocol,
         storageService: StorageServiceProtocol = StorageService()) {
        self.presenter = presenter
        self.storageService = storageService
    }
    
    func fetchFavoriteRecipes() {
        do {
            let favorites = try storageService.loadFavoriteRecipes()
            presenter.presentFavoriteRecipes(favorites)
        } catch {
            presenter.presentError(error)
        }
    }
    
    func removeRecipeFromFavorites(_ recipe: Recipe) {
        do {
            try storageService.removeRecipeFromFavorites(recipe)
            fetchFavoriteRecipes() // Refresh the list
        } catch {
            presenter.presentError(error)
        }
    }
}
