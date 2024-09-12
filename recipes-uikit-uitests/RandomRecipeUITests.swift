//
//  RandomRecipeUITests.swift
//  recipes-uikit-uitests
//
//  Created by Sergey Bendak on 12.09.2024.
//

import XCTest

final class RandomRecipeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testRecipeViewElementsExist() {
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "Get Recipe button should exist")
        
        let recipeImage = app.images["RecipeImageView"]
        XCTAssertTrue(recipeImage.exists, "Recipe image should exist")
        
        let ingredientsTitleLabel = app.staticTexts["IngredientsTitleLabel"]
        XCTAssertTrue(ingredientsTitleLabel.exists, "Ingredients title label should exist")
        
        let youtubeButton = app.buttons["YoutubeButton"]
        XCTAssertTrue(youtubeButton.exists, "YouTube button should exist")
        
        let sourceButton = app.buttons["SourceButton"]
        XCTAssertTrue(sourceButton.exists, "Source button should exist")
    }
    
    func testFirstTabIsSelectedOnLaunch() {
        let app = XCUIApplication()
        app.launch()

        let firstTab = app.tabBars.buttons["RandomTab"]
        XCTAssertTrue(firstTab.exists, "The first tab 'Random Recipe' should exist")
        XCTAssertTrue(firstTab.isSelected, "The first tab 'Random Recipe' should be selected on launch")
    }
    
    func testGetRandomRecipeButtonTapped() {
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "Get Recipe button should exist")
        
        getRecipeButton.tap()
        
        let recipeImage = app.images["RecipeImageView"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: recipeImage, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(recipeImage.exists, "Recipe image should exist after fetching random recipe")
    }
}
