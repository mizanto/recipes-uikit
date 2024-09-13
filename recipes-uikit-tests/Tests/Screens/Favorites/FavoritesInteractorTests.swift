//
//  FavoritesInteractorTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class FavoritesInteractorTests: XCTestCase {
    
    var interactor: FavoritesInteractor!
    var mockPresenter: MockFavoritesPresenter!
    var mockRouter: MockFavoritesRouter!
    var mockStorageService: MockStorageService!
    var recipe: RecipeDataModel!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockFavoritesPresenter()
        mockRouter = MockFavoritesRouter()
        mockStorageService = MockStorageService()
        interactor = FavoritesInteractor(presenter: mockPresenter,
                                         router: mockRouter,
                                         storageService: mockStorageService)
        recipe = RecipeDataModel.mock
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockRouter = nil
        mockStorageService = nil
        recipe = nil
        super.tearDown()
    }
    
    func testFetchFavoriteRecipesSuccess() {
        recipe.isFavorite = true
        mockStorageService.recipes = [recipe, recipe]
        
        interactor.fetchFavoriteRecipes()
        
        XCTAssertTrue(mockPresenter.presentFavoriteRecipesCalled)
        XCTAssertEqual(mockPresenter.presentedRecipes?.count, 2)
    }
    
    func testFetchFavoriteRecipesFailure() {
        mockStorageService.error = .itemNotFound
        
        interactor.fetchFavoriteRecipes()
        
        XCTAssertTrue(mockPresenter.presentErrorCalled)
        XCTAssertEqual(mockPresenter.error as? StorageError, .itemNotFound)
    }
    
    func testRemoveRecipeFromFavoritesSuccess() {
        recipe.isFavorite = true
        mockStorageService.recipes = [recipe]
        
        interactor.removeRecipeFromFavorites(withId: recipe.id)
        
        XCTAssertFalse(mockStorageService.recipes[0].isFavorite)
        XCTAssertTrue(mockPresenter.presentFavoriteRecipesCalled)
    }
    
    func testRemoveRecipeFromFavoritesFailureItemNotFound() {
        mockStorageService.error = .itemNotFound
        
        interactor.removeRecipeFromFavorites(withId: "invalid_id")
        
        XCTAssertTrue(mockPresenter.presentErrorCalled)
        XCTAssertEqual(mockPresenter.error as? StorageError, .itemNotFound)
    }
    
    func testSelectRecipeCallsRouter() {
        interactor.selectRecipe(withId: "1")
        
        XCTAssertTrue(mockRouter.navigateToRecipeDetailCalled)
        XCTAssertEqual(mockRouter.selectedRecipeId, "1")
    }
}
