//
//  MockRecipeView.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockRecipeView: RecipeViewProtocol {
    var displayedRecipe: RandomRecipeViewModel?
    var displayedError: String?
    
    func displayRecipe(_ viewModel: RandomRecipeViewModel) {
        displayedRecipe = viewModel
    }
    
    func displayError(_ errorMessage: String) {
        displayedError = errorMessage
    }
}
