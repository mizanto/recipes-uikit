//
//  FavoritesPresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func presentFavoriteRecipes(_ recipes: [StoredRecipe])
    func presentError(_ error: Error)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    func presentFavoriteRecipes(_ recipes: [StoredRecipe]) {
        AppLogger.shared.info("Presenting \(recipes.count) favorite recipes", category: .ui)
        let viewModel = recipes.map { recipe in
            FavoriteRecipeViewModel(
                id: recipe.id,
                mealName: recipe.mealName,
                category: recipe.category,
                area: recipe.area,
                imageUrl: recipe.mealThumbURL
            )
        }
        view?.displayFavoriteRecipes(viewModel)
    }
    
    func presentError(_ error: Error) {
        AppLogger.shared.error("Error presenting favorite recipes: \(error.localizedDescription)", category: .ui)
        view?.displayError(error.localizedDescription)
    }
}
