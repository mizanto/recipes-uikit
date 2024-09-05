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
        AppLogger.shared.info("Fetching favorite recipes from storage", category: .database)
        do {
            let favorites = try storageService.loadFavoriteRecipes()
            AppLogger.shared.info("Fetched \(favorites.count) favorite recipes", category: .database)
            presenter?.presentFavoriteRecipes(favorites)
        } catch {
            AppLogger.shared.error("Failed to fetch favorite recipes: \(error.localizedDescription)", category: .database)
            presenter?.presentError(error)
        }
    }
    
    func removeRecipeFromFavorites(_ viewModel: FavoriteRecipeViewModel) {
        AppLogger.shared.info("Removing recipe '\(viewModel.mealName)' from favorites", category: .database)
        do {
            let favorites = try storageService.loadFavoriteRecipes()
            if let recipe = favorites.first(where: { $0.mealName == viewModel.mealName }) {
                try storageService.removeRecipeFromFavorites(recipe)
                AppLogger.shared.info("Recipe '\(viewModel.mealName)' removed from favorites", category: .database)
                fetchFavoriteRecipes()
            } else {
                AppLogger.shared.error("Recipe '\(viewModel.mealName)' not found in favorites", category: .database)
            }
        } catch {
            AppLogger.shared.error("Failed to remove recipe '\(viewModel.mealName)' from favorites: \(error.localizedDescription)", category: .database)
            presenter?.presentError(error)
        }
    }
    
    func selectRecipe(_ viewModel: FavoriteRecipeViewModel) {
        AppLogger.shared.info("Navigating to details of recipe with ID: \(viewModel.id)", category: .ui)
        router?.navigateToRecipeDetail(with: viewModel.id)
    }
}
