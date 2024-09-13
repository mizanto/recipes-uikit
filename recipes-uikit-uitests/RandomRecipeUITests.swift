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
        
        // Ensure the test starts on the Random Recipe tab
        checkFirstTabIsSelectedOnLaunch()
    }
    
    // Test to verify that all necessary elements exist in the recipe view
    func testRecipeViewElementsExist() {
        checkRecipeViewElementsExist()
    }
    
    // Test to verify that tapping the "Get Recipe" button fetches a random recipe and displays it
    func testGetRandomRecipeButtonTapped() {
        tapGetRecipeButton()
        checkRecipeIsDisplayed()
    }
    
    // Verify the first tab ("Random Recipe") is selected on launch
    func checkFirstTabIsSelectedOnLaunch() {
        let firstTab = app.tabBars.buttons["RandomTab"]
        XCTAssertTrue(firstTab.exists, "The first tab 'Random Recipe' should exist")
        XCTAssertTrue(firstTab.isSelected, "The first tab 'Random Recipe' should be selected on launch")
    }
    
    // Verify all required elements exist in the recipe view
    func checkRecipeViewElementsExist() {
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
    
    // Tap the "Get Recipe" button to fetch a random recipe
    func tapGetRecipeButton() {
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "Get Recipe button should exist")
        getRecipeButton.tap()
    }
    
    // Check that a recipe is displayed after tapping "Get Recipe"
    func checkRecipeIsDisplayed() {
        let recipeImage = app.images["RecipeImageView"]
        waitForElementToAppear(recipeImage)
    }
    
    // Wait for a specific element to appear on the screen with a timeout
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element should appear within \(timeout) seconds")
    }
}
