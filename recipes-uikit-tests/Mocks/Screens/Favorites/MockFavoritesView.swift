//
//  MockFavoritesView.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockFavoritesView: FavoritesViewProtocol {
    var displayFavoriteRecipesCalled = false
    var displayPlaceholderCalled = false
    var displayErrorCalled = false
    var displayedRecipes: [FavoriteRecipeViewModel]?
    var errorMessage: String?
    
    func displayFavoriteRecipes(_ viewModel: [FavoriteRecipeViewModel]) {
        displayFavoriteRecipesCalled = true
        displayedRecipes = viewModel
    }
    
    func displayPlaceholder() {
        displayPlaceholderCalled = true
    }
    
    func displayError(_ message: String) {
        displayErrorCalled = true
        errorMessage = message
    }
}
