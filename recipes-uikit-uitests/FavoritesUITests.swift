//
//  FavoritesUITests.swift
//  recipes-uikit-uitests
//
//  Created by Sergey Bendak on 13.09.2024.
//

import XCTest

final class FavoritesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Navigate to Favorites tab and remove all favorites before each test to ensure a clean state.
        navigateToTab("FavoritesTab")
        removeAllFavorites()
    }
    
    func testAddAndRemoveRecipeFromFavorites() {
        // Navigate to Random tab to get a random recipe.
        navigateToTab("RandomTab")
        
        // Add a recipe to favorites.
        addRecipeToFavorites()
        
        // Navigate to Favorites tab and verify the recipe is added.
        navigateToTab("FavoritesTab")
        checkRecipeIsInFavorites()
        
        // Delete the added recipe and verify the favorites list is empty.
        deleteFavoriteRecipe()
        checkFavoritesIsEmpty()
    }
    
    func testOpenRecipeDetailFromFavorites() {
        // Navigate to Random tab to get a random recipe.
        navigateToTab("RandomTab")
        
        // Add a recipe to favorites.
        addRecipeToFavorites()
        
        // Navigate to Favorites tab.
        navigateToTab("FavoritesTab")
        
        // Open the detailed view of the first recipe in Favorites.
        openRecipeDetailFromFavorites()
        
        // Verify that the detailed view of the recipe is displayed.
        checkRecipeDetailScreen()
    }
    
    // Navigate to a specific tab by its accessibility identifier.
    func navigateToTab(_ tab: String) {
        let tabButton = app.tabBars.buttons[tab]
        XCTAssertTrue(tabButton.exists, "\(tab) tab should exist")
        tabButton.tap()
    }
    
    // Add a random recipe to the favorites.
    func addRecipeToFavorites() {
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "The Get Recipe button should exist")
        getRecipeButton.tap()
        
        // Wait until the recipe image appears to ensure the recipe is loaded.
        let recipeImageView = app.images["RecipeImageView"]
        waitForElementToAppear(recipeImageView)
        
        // Tap the Favorite button to add the recipe to favorites.
        let favoriteButton = app.buttons["FavoriteButton"]
        XCTAssertTrue(favoriteButton.exists, "The Favorite button should exist")
        favoriteButton.tap()
    }
    
    // Delete the first recipe from the favorites by long-pressing it and confirming deletion.
    func deleteFavoriteRecipe() {
        let favoritesCollectionView = app.collectionViews["FavoritesCollectionView"]
        let firstCell = favoritesCollectionView.cells.element(boundBy: 0)
        firstCell.press(forDuration: 1.0)
        
        // Tap the "Delete" button from the context menu.
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists, "The Delete button should exist in the context menu")
        deleteButton.tap()
    }
    
    // Check that there is at least one recipe in the favorites collection view.
    func checkRecipeIsInFavorites() {
        let favoritesCollectionView = app.collectionViews["FavoritesCollectionView"]
        XCTAssertGreaterThan(favoritesCollectionView.cells.count, 0, "There should be at least one favorite recipe")
    }
    
    // Check that the Favorites screen is empty and shows a placeholder view.
    func checkFavoritesIsEmpty() {
        let placeholderView = app.otherElements["FavoritesPlaceholderView"]
        XCTAssertTrue(placeholderView.waitForExistence(timeout: 5), "The placeholder view should be displayed when there are no favorites")
    }
    
    // Remove all favorite recipes by iterating through the collection and deleting each one.
    func removeAllFavorites() {
        let favoritesCollectionView = app.collectionViews["FavoritesCollectionView"]
        
        while favoritesCollectionView.cells.count > 0 {
            let firstCell = favoritesCollectionView.cells.element(boundBy: 0)
            firstCell.press(forDuration: 1.0)
            
            let deleteButton = app.buttons["Delete"]
            XCTAssertTrue(deleteButton.exists, "The Delete button should exist in the context menu")
            deleteButton.tap()
            
            // Wait for UI to update after deletion.
            sleep(1)
        }
    }
    
    // Open the detailed view of the first recipe in Favorites.
    func openRecipeDetailFromFavorites() {
        let favoritesCollectionView = app.collectionViews["FavoritesCollectionView"]
        let firstCell = favoritesCollectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first recipe cell should exist in Favorites")
        firstCell.tap()
    }
    
    // Check that the detailed view of a recipe is displayed with all necessary elements.
    func checkRecipeDetailScreen() {
        let recipeImageView = app.images["RecipeImageView"]
        XCTAssertTrue(recipeImageView.waitForExistence(timeout: 5), "The Recipe Image view should be displayed")
        
        let categoryLabel = app.staticTexts["CategoryLabel"]
        XCTAssertTrue(categoryLabel.exists, "The Category Label should be displayed")
        
        let ingredientsLabel = app.staticTexts["IngredientsLabel"]
        XCTAssertTrue(ingredientsLabel.exists, "The Ingredients Label should be displayed")
        
        let instructionsLabel = app.staticTexts["InstructionsLabel"]
        XCTAssertTrue(instructionsLabel.exists, "The Instructions Label should be displayed")
    }
    
    // Wait for a specific element to appear on the screen with a timeout.
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element should appear within \(timeout) seconds")
    }
}
