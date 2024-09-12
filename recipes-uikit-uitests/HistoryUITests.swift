//
//  HistoryUITests.swift
//  recipes-uikit-uitests
//
//  Created by Sergey Bendak on 12.09.2024.
//

import XCTest

final class HistoryUITests: XCTestCase {

    var app: XCUIApplication!
    var historyTab: XCUIElement!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        loadRecipe()

        historyTab = app.tabBars.buttons["HistoryTab"]
        XCTAssertTrue(historyTab.exists, "The history tab should exist")
        historyTab.tap()
    }
    
    private func loadRecipe() {
        let getRecipeButton = app.buttons["GetRecipeButton"]
        XCTAssertTrue(getRecipeButton.exists, "The Get Random Recipe button should exist")
        getRecipeButton.tap()
        
        let recipeImageView = app.images["RecipeImageView"]
        let recipeLoadedExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: recipeImageView
        )
        let loadingResult = XCTWaiter().wait(for: [recipeLoadedExpectation], timeout: 5)
        XCTAssertEqual(loadingResult, .completed, "The random recipe should be fetched and displayed")
    }
    
    func testHistoryTabIsSelected() {
        XCTAssertTrue(historyTab.exists, "The history tab should exist")
        XCTAssertTrue(historyTab.isSelected, "The history tab should be selected")
        
        let tableView = app.tables["HistoryTableView"]
        XCTAssertTrue(tableView.exists, "The history table view should exist")
    }

    func testClearHistoryButtonTap() {
        let clearButton = app.navigationBars.buttons["Clear"]
        XCTAssertTrue(clearButton.exists, "The Clear button should exist")

        clearButton.tap()

        let alert = app.alerts["Clear History"]
        XCTAssertTrue(alert.exists, "The Clear History alert should be presented")

        let confirmButton = alert.buttons["Clear"]
        XCTAssertTrue(confirmButton.exists, "The Clear button in alert should exist")

        confirmButton.tap()

        let placeholderView = app.otherElements["PlaceholderView"]
        XCTAssertTrue(placeholderView.exists, "The placeholder view should be displayed after clearing history")
        
        let tableView = app.tables["HistoryTableView"]
        XCTAssertFalse(tableView.exists, "The history table view should be hidden after clearing history")
    }
}
