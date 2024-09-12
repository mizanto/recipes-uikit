//
//  MockRecipePresenter.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 9.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockRecipePresenter: RecipePresenterProtocol {

    var recipePresented: RecipeDataModel?
    var errorPresented: Error?
    
    var isPresentRecipeCalled = false
    var isPresentErrorCalled = false
    
    func presentRecipe(_ recipe: recipes_uikit.RecipeDataModel,
                       onYoutubeButton: @escaping recipes_uikit.VoidHandler,
                       onSourceButton: @escaping recipes_uikit.VoidHandler) {
        recipePresented = recipe
        isPresentRecipeCalled = true
    }
    
    func presentError(_ error: Error) {
        errorPresented = error
        isPresentErrorCalled = true
    }
}
