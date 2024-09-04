//
//  FavoritesPresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func presentFavoriteRecipes(_ recipes: [Recipe])
    func presentError(_ error: Error)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    func presentFavoriteRecipes(_ recipes: [Recipe]) {
        let viewModel = recipes.map { recipe in
            FavoriteRecipeViewModel(
                mealName: recipe.mealName,
                category: recipe.category,
                area: recipe.area,
                imageUrl: recipe.mealThumbURL
            )
        }
        view?.displayFavoriteRecipes(viewModel)
    }
    
    func presentError(_ error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
