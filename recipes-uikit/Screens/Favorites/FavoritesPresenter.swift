//
//  FavoritesPresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func presentFavoriteRecipes(_ recipes: [RecipeDataModel])
    func presentError(_ error: Error)
}

class FavoritesPresenter: FavoritesPresenterProtocol {

    weak var view: FavoritesViewProtocol?

    init(view: FavoritesViewProtocol) {
        self.view = view
    }

    func presentFavoriteRecipes(_ recipes: [RecipeDataModel]) {
        AppLogger.shared.info("Presenting \(recipes.count) favorite recipes", category: .ui)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if recipes.isEmpty {
                self.view?.displayPlaceholder()
            } else {
                let viewModel = self.mapToViewModel(recipes)
                self.view?.displayFavoriteRecipes(viewModel)
            }
        }
    }

    func presentError(_ error: Error) {
        AppLogger.shared.error("Error presenting favorite recipes: \(error.localizedDescription)", category: .ui)
        DispatchQueue.main.async { [weak self] in
            self?.view?.displayError(error.localizedDescription)
        }
    }

    private func mapToViewModel(_ recipes: [RecipeDataModel]) -> [FavoriteRecipeViewModel] {
        return recipes.map { recipe in
            FavoriteRecipeViewModel(
                id: recipe.id,
                mealName: recipe.mealName,
                category: recipe.category,
                area: recipe.area,
                imageUrl: recipe.mealThumbURL
            )
        }
    }
}
