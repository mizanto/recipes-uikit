//
//  MockRecipeView.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockRecipeView: RecipeViewProtocol {
    var displayedRecipe: RecipeViewModel?
    var displayedError: String?
    
    func displayRecipe(_ viewModel: RecipeViewModel) {
        displayedRecipe = viewModel
    }
    
    func displayError(_ errorMessage: String) {
        displayedError = errorMessage
    }
}
