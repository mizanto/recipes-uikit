//
//  HistoryViewControllerTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class HistoryViewControllerTests: XCTestCase {
    var viewController: HistoryViewController!
    var mockInteractor: MockHistoryInteractor!
    
    override func setUp() {
        super.setUp()
        viewController = HistoryViewController()
        mockInteractor = MockHistoryInteractor()
        viewController.interactor = mockInteractor
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testViewWillAppearCallsFetchHistory() {
        viewController.viewWillAppear(false)
        
        XCTAssertTrue(mockInteractor.fetchHistoryCalled)
    }
    
    func testDisplayRecipeHistoryShowsTableViewAndHidesPlaceholder() {
        let recipe = HistoryViewModel(mealName: "Pizza", dateAdded: "Today")
        let recipes = [recipe]
        
        viewController.displayRecipeHistory(recipes)
        
        XCTAssertFalse(viewController.tableView.isHidden)
        XCTAssertTrue(viewController.placeholderView.isHidden)
        XCTAssertEqual(viewController.recipes.count, 1)
    }
    
    func testDisplayPlaceholderShowsPlaceholderAndHidesTableView() {
        viewController.displayPlaceholder()
        
        XCTAssertTrue(viewController.placeholderView.isHidden == false)
        XCTAssertTrue(viewController.tableView.isHidden)
    }
    
    func testConfirmClearHistoryCallsClearHistoryOnInteractor() {
        viewController.confirmClearHistory()
        
        XCTAssertTrue(mockInteractor.clearHistoryCalled, "Expected clearHistory() to be called on the interactor")
    }
}
