//
//  RecipePresenterTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class RecipePresenterTests: XCTestCase {
    var presenter: RecipePresenter!
    var mockView: MockRecipeView!
    
    override func setUp() {
        super.setUp()
        
        mockView = MockRecipeView()
        presenter = RecipePresenter(view: mockView)
        
        XCTAssertNotNil(presenter.view, "Presenter's view should not be nil")
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testPresentRecipe() {
        let recipe = RecipeDataModel.mock
        let expectation = XCTestExpectation(description: "Recipe should be presented")
        
        presenter.presentRecipe(recipe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.mockView.displayedRecipe)
            XCTAssertEqual(self.mockView.displayedRecipe?.mealName, recipe.mealName)
            XCTAssertEqual(self.mockView.displayedRecipe?.mealThumbURL, recipe.mealThumbURL)
            XCTAssertEqual(self.mockView.displayedRecipe?.category, recipe.category)
            XCTAssertEqual(self.mockView.displayedRecipe?.area, recipe.area)
            XCTAssertEqual(self.mockView.displayedRecipe?.instructions, recipe.instructions)
            XCTAssertEqual(self.mockView.displayedRecipe?.youtubeURL, recipe.youtubeURL)
            XCTAssertEqual(self.mockView.displayedRecipe?.sourceURL, recipe.sourceURL)
            XCTAssertEqual(self.mockView.displayedRecipe?.isFavorite, recipe.isFavorite)
            XCTAssertEqual(self.mockView.displayedRecipe?.ingredients, "Chicken: 200g")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPresentError() {
        let message = "Test error occurred"
        let expectation = XCTestExpectation(description: "Error should be presented")

        let testError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: message])
        
        presenter.presentError(testError)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            XCTAssertNotNil(self.mockView.displayedError)
            XCTAssertEqual(self.mockView.displayedError, message)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
