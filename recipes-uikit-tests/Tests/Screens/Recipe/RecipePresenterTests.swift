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
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testPresentRecipe() {
        let recipe = RecipeDataModel.mock
        
        presenter.presentRecipe(recipe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        }
    }
    
    func testPresentError() {
        let testError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error occurred"])
        
        presenter.presentError(testError)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockView.displayedError)
            XCTAssertEqual(self.mockView.displayedError, "Test error occurred")
        }
    }
}
