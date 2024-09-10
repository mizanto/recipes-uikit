//
//  BaseRecipeInteractorTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class BaseRecipeInteractorTests: XCTestCase {
    var interactor: BaseRecipeInteractor!
    var mockPresenter: MockRecipePresenter!
    var mockStorageService: MockStorageService!
    var recipe: RecipeDataModel!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockRecipePresenter()
        mockStorageService = MockStorageService()
        
        recipe = RecipeDataModel.mock
        
        mockStorageService.recipes.append(recipe)
        interactor = BaseRecipeInteractor(presenter: mockPresenter, 
                                          storageService: mockStorageService)
        interactor.currentRecipe = recipe
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageService = nil
        recipe = nil
        super.tearDown()
    }
    
    func testFetchRecipeThrowsError() {
        interactor.fetchRecipe()
        
        XCTAssertTrue(mockPresenter.isPresentErrorCalled)
        XCTAssertEqual(mockPresenter.errorPresented as? BaseRecipeInteractor.InteractorError, BaseRecipeInteractor.InteractorError.methodNotImplemented)
    }
    
    func testToggleFavoriteStatusToAdd() {
        interactor.toggleFavoriteStatus()
        
        XCTAssertTrue(mockPresenter.isPresentRecipeCalled)
        XCTAssertEqual(mockPresenter.recipePresented?.isFavorite, true)
        XCTAssertTrue(mockStorageService.recipes.contains(where: { $0.id == recipe.id && $0.isFavorite }))
    }
    
    func testToggleFavoriteStatusToRemove() {
        recipe.isFavorite = true
        mockStorageService.recipes = [recipe]
        
        interactor.toggleFavoriteStatus()
        
        XCTAssertTrue(mockPresenter.isPresentRecipeCalled)
        XCTAssertEqual(mockPresenter.recipePresented?.isFavorite, false)
        XCTAssertFalse(mockStorageService.recipes.contains(where: { $0.id == recipe.id && $0.isFavorite }))
    }
}
