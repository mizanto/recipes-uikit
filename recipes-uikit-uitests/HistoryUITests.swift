//
//  HistoryUITests.swift
//  recipes-uikit-uitests
//
//  Created by Sergey Bendak on 12.09.2024.
//

import XCTest

final class HistoryUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        // Load a random recipe to populate the history.
        loadRecipe()
        
        // Navigate to the History tab.
        navigateToTab("HistoryTab")
    }
    
    // Test to verify clearing history functionality.
    func testClearHistoryButtonTap() {
        checkHistoryTabIsSelected()
        checkHistoryTableExists()
        clearHistory()
        checkHistoryIsCleared()
    }
    
    // Navigate to a specific tab by its accessibility identifier.
    func navigateToTab(_ tab: String) {
        let tabButton = app.tabBars.buttons[tab]
        XCTAssertTrue(tabButton.exists, "\(tab) tab should exist")
        tabButton.tap()
    }
    
    // Load a random recipe to ensure the history has data.
    func loadRecipe() {
        navigateToTab("RandomTab")
        
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "The Get Random Recipe button should exist")
        getRecipeButton.tap()
        
        let recipeImageView = app.images["RecipeImageView"]
        waitForElementToAppear(recipeImageView)
    }
    
    // Check that the History tab is selected.
    func checkHistoryTabIsSelected() {
        let historyTab = app.tabBars.buttons["HistoryTab"]
        XCTAssertTrue(historyTab.exists, "The history tab should exist")
        XCTAssertTrue(historyTab.isSelected, "The history tab should be selected")
    }
    
    // Check that the history table view exists.
    func checkHistoryTableExists() {
        let tableView = app.tables["HistoryTableView"]
        XCTAssertTrue(tableView.exists, "The history table view should exist")
    }
    
    // Clear the history by tapping the Clear button and confirming the alert.
    func clearHistory() {
        let clearButton = app.navigationBars.buttons["Clear"]
        XCTAssertTrue(clearButton.exists, "The Clear button should exist")
        clearButton.tap()
        
        let alert = app.alerts["Clear History"]
        XCTAssertTrue(alert.exists, "The Clear History alert should be presented")
        
        let confirmButton = alert.buttons["Clear"]
        XCTAssertTrue(confirmButton.exists, "The Clear button in alert should exist")
        confirmButton.tap()
    }
    
    // Check that the history is cleared and the placeholder view is shown.
    func checkHistoryIsCleared() {
        let placeholderView = app.otherElements["PlaceholderView"]
        XCTAssertTrue(placeholderView.waitForExistence(timeout: 5), "The placeholder view should be displayed after clearing history")
        
        let tableView = app.tables["HistoryTableView"]
        XCTAssertFalse(tableView.exists, "The history table view should be hidden after clearing history")
    }
    
    // Wait for a specific element to appear on the screen with a timeout.
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element should appear within \(timeout) seconds")
    }
}
