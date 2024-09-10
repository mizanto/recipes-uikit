//
//  MockFavoritesInteractor.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockFavoritesInteractor: FavoritesInteractorProtocol {
    var fetchFavoriteRecipesCalled = false
    var removeRecipeFromFavoritesCalled = false
    var selectRecipeCalled = false
    
    var removedRecipeId: String?
    var selectedRecipeId: String?
    
    func fetchFavoriteRecipes() {
        fetchFavoriteRecipesCalled = true
    }
    
    func removeRecipeFromFavorites(withId id: String) {
        removeRecipeFromFavoritesCalled = true
        removedRecipeId = id
    }
    
    func selectRecipe(withId id: String) {
        selectRecipeCalled = true
        selectedRecipeId = id
    }
}
