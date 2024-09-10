//
//  RecipePresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RecipePresenterProtocol: AnyObject {
    func presentRecipe(_ recipe: RecipeDataModel)
    func presentError(_ error: Error)
}

class RecipePresenter: RecipePresenterProtocol {
    
    weak var view: RecipeViewProtocol?
    
    init(view: RecipeViewProtocol) {
        self.view = view
    }
    
    func presentRecipe(_ recipe: RecipeDataModel) {
        AppLogger.shared.info("Preparing to present recipe: \(recipe.mealName)", category: .ui)
        
        let viewModel = RandomRecipeViewModel(
            mealName: recipe.mealName,
            mealThumbURL: recipe.mealThumbURL,
            category: recipe.category,
            area: recipe.area,
            ingredients: recipe.ingredients
                .map { "\($0.name): \($0.measure)" }
                .joined(separator: "\n"),
            instructions: recipe.instructions,
            youtubeURL: recipe.youtubeURL,
            sourceURL: recipe.sourceURL,
            isFavorite: recipe.isFavorite
        )
        
        DispatchQueue.main.async {
            AppLogger.shared.info("Presenting кecipe: \(recipe.mealName)", category: .ui)
            self.view?.displayRecipe(viewModel)
        }
    }
    
    func presentError(_ error: Error) {
        AppLogger.shared.error("Presenting error: \(error.localizedDescription)", category: .ui)
        DispatchQueue.main.async {
            self.view?.displayError(error.localizedDescription)
        }
    }
}
