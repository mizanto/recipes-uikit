//
//  MockFavoritesRouter.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockFavoritesRouter: FavoritesRouterProtocol {
    var navigateToRecipeDetailCalled = false
    var selectedRecipeId: String?
    
    func navigateToRecipeDetail(with id: String) {
        navigateToRecipeDetailCalled = true
        selectedRecipeId = id
    }
}
