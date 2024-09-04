//
//  FavoritesInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesInteractorProtocol {
    func fetchFavoriteRecipes()
    func removeRecipeFromFavorites(_ viewModel: FavoriteRecipeViewModel)
    func selectRecipe(_ viewModel: FavoriteRecipeViewModel)
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    
    var presenter: FavoritesPresenterProtocol?
    var router: FavoritesRouterProtocol?
    
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    func fetchFavoriteRecipes() {
        do {
            let favorites = try storageService.loadFavoriteRecipes()
            presenter?.presentFavoriteRecipes(favorites)
        } catch {
            presenter?.presentError(error)
        }
    }
    
    func removeRecipeFromFavorites(_ viewModel: FavoriteRecipeViewModel) {
        do {
            let favorites = try storageService.loadFavoriteRecipes()
            if let recipe = favorites.first(where: { $0.mealName == viewModel.mealName }) {
                try storageService.removeRecipeFromFavorites(recipe)
                fetchFavoriteRecipes()
            }
        } catch {
            presenter?.presentError(error)
        }
    }
    
    func selectRecipe(_ viewModel: FavoriteRecipeViewModel) {
        router?.navigateToRecipeDetail(with: viewModel.id)
    }
}
