//
//  FavoritesPresenterTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class FavoritesPresenterTests: XCTestCase {
    
    var presenter: FavoritesPresenter!
    var mockView: MockFavoritesView!
    
    override func setUp() {
        super.setUp()
        mockView = MockFavoritesView()
        presenter = FavoritesPresenter(view: mockView)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testPresentFavoriteRecipes_WithNonEmptyRecipes() {
        let recipes = [RecipeDataModel.mock]
        
        presenter.presentFavoriteRecipes(recipes)
        
        XCTAssertTrue(mockView.displayFavoriteRecipesCalled)
        XCTAssertEqual(mockView.displayedRecipes?.count, recipes.count)
        XCTAssertEqual(mockView.displayedRecipes?.first?.id, recipes.first?.id)
        XCTAssertEqual(mockView.displayedRecipes?.first?.mealName, recipes.first?.mealName)
    }
    
    func testPresentFavoriteRecipes_WithEmptyRecipes() {
        let recipes: [RecipeDataModel] = []
        
        presenter.presentFavoriteRecipes(recipes)
        
        XCTAssertTrue(mockView.displayPlaceholderCalled)
        XCTAssertFalse(mockView.displayFavoriteRecipesCalled)
    }
    
    func testPresentError_CallsDisplayError() {
        let message = "Test Error"
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
        
        presenter.presentError(error)
        
        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertEqual(mockView.errorMessage, message)
    }
}
