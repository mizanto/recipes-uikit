//
//  RecipePresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol RecipePresenterProtocol: AnyObject {
    func presentRecipe(_ recipe: StoredRecipe, isFavorite: Bool)
    func presentError(_ error: Error)
}

class RecipePresenter: RecipePresenterProtocol {
    
    weak var view: RecipeViewProtocol?
    
    init(view: RecipeViewProtocol) {
        self.view = view
    }
    
    func presentRecipe(_ recipe: StoredRecipe, isFavorite: Bool) {
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
            isFavorite: isFavorite
        )
        
        DispatchQueue.main.async {
            self.view?.displayRecipe(viewModel)
        }
    }
    
    func presentError(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.displayError(error.localizedDescription)
        }
    }
}
