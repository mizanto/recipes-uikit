//
//  MockFavoritesPresenter.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockFavoritesPresenter: FavoritesPresenterProtocol {
    var presentedRecipes: [RecipeDataModel]?
    var error: Error?
    
    var presentFavoriteRecipesCalled = false
    var presentErrorCalled = false
    
    func presentFavoriteRecipes(_ recipes: [RecipeDataModel]) {
        presentFavoriteRecipesCalled = true
        presentedRecipes = recipes
    }
    
    func presentError(_ error: Error) {
        presentErrorCalled = true
        self.error = error
    }
}
