//
//  RecipeDetailInteractorTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 9.09.2024.
//

import XCTest

@testable import recipes_uikit

class RecipeDetailInteractorTests: XCTestCase {
    var interactor: RecipeDetailInteractor!
    var mockPresenter: MockRecipePresenter!
    var mockStorageService: MockStorageService!
    var recipe: RecipeDataModel!
    
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockRecipePresenter()
        mockStorageService = MockStorageService()
        
        recipe = RecipeDataModel.mock
        
        mockStorageService.recipes.append(recipe)
        interactor = RecipeDetailInteractor(presenter: mockPresenter, storageService: mockStorageService, recipeId: recipe.id)
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageService = nil
        recipe = nil
        super.tearDown()
    }
    
    func testFetchRecipeSuccess() {
        interactor.fetchRecipe()
        
        XCTAssertTrue(mockPresenter.isPresentRecipeCalled)
        XCTAssertNotNil(mockPresenter.recipePresented)
        XCTAssertEqual(mockPresenter.recipePresented?.id, recipe.id)
        XCTAssertNil(mockPresenter.errorPresented)
    }
    
    func testFetchRecipeFailure() {
        mockStorageService.error = StorageServiceError.itemNotFound
        
        interactor.fetchRecipe()
        
        XCTAssertTrue(mockPresenter.isPresentErrorCalled)
        XCTAssertNil(mockPresenter.recipePresented)
        XCTAssertNotNil(mockPresenter.errorPresented)
        XCTAssertEqual(mockPresenter.errorPresented as? StorageServiceError, StorageServiceError.itemNotFound)
    }
}
