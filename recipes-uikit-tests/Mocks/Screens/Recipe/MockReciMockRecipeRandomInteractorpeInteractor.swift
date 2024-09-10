//
//  MockRecipeRandomInteractor.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockRecipeRandomInteractor: RecipeRandomInteractorProtocol {
    var fetchRecipeCalled = false
    var toggleFavoriteStatusCalled = false
    var fetchRandomRecipeCalled = false
    
    func fetchRecipe() {
        fetchRecipeCalled = true
    }
    
    func toggleFavoriteStatus() {
        toggleFavoriteStatusCalled = true
    }
    
    func fetchRandomRecipe() {
        fetchRandomRecipeCalled = true
    }
}
