//
//  FavoritesInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesInteractorProtocol {
    func fetchFavoriteRecipes()
    func removeRecipeFromFavorites(withId id: String)
    func selectRecipe(withId id: String)
}

class FavoritesInteractor: FavoritesInteractorProtocol {

    private let presenter: FavoritesPresenterProtocol
    private let router: FavoritesRouterProtocol

    private let storageService: StorageServiceProtocol

    init(presenter: FavoritesPresenterProtocol,
         router: FavoritesRouterProtocol,
         storageService: StorageServiceProtocol) {
        self.presenter = presenter
        self.router = router
        self.storageService = storageService
    }

    func fetchFavoriteRecipes() {
        AppLogger.shared.info("Fetching favorite recipes from storage", category: .database)
        do {
            let favorites = try storageService.getFavoriteRecipes()
            AppLogger.shared.info("Fetched \(favorites.count) favorite recipes", category: .database)
            presenter.presentFavoriteRecipes(favorites)
        } catch {
            AppLogger.shared.error("Failed to fetch favorite recipes: \(error.localizedDescription)",
                                   category: .database)
            presenter.presentError(error)
        }
    }

    func removeRecipeFromFavorites(withId id: String) {
        AppLogger.shared.info("Removing recipe with ID '\(id)' from favorites", category: .database)
        do {
            let recipe = try storageService.getRecipe(by: id)
            try storageService.removeRecipeFromFavorites(recipe)
            AppLogger.shared.info("Recipe with ID '\(id)' removed from favorites", category: .database)
            fetchFavoriteRecipes()
        } catch let storageError as StorageError {
            AppLogger.shared.error("Storage error while removing recipe from favorites: \(storageError.localizedDescription)", category: .database)
            presenter.presentError(storageError)
        } catch {
            AppLogger.shared.error(
                "Failed to remove recipe with ID '\(id)' from favorites: \(error.localizedDescription)",
                category: .database
            )
            presenter.presentError(error)
        }
    }

    func selectRecipe(withId id: String) {
        AppLogger.shared.info("Navigating to details of recipe with ID: \(id)", category: .ui)
        router.navigateToRecipeDetail(with: id)
    }
}
