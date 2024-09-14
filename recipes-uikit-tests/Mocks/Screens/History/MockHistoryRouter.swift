//
//  MockHistoryRouter.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 14.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockHistoryRouter: HistoryRouterProtocol {
    var navigateToRecipeDetailCalled = false
    var selectedRecipeId: String?
    
    func navigateToRecipeDetail(with id: String) {
        navigateToRecipeDetailCalled = true
        selectedRecipeId = id
    }
}
