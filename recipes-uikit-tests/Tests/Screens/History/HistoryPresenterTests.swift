//
//  HistoryPresenterTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class HistoryPresenterTests: XCTestCase {
    var presenter: HistoryPresenter!
    var mockView: MockHistoryView!
    var historyItem: HistoryItemDataModel!

    override func setUp() {
        super.setUp()
        
        mockView = MockHistoryView()
        presenter = HistoryPresenter(view: mockView)
        historyItem = HistoryItemDataModel(id: "1", 
                                           mealName: "Pizza",
                                           date: Date())
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        historyItem = nil
        
        super.tearDown()
    }

    func testPresentRecipeHistoryWithEmptyHistory() {
        let emptyHistory: [HistoryItemDataModel] = []

        presenter.presentRecipeHistory(emptyHistory)

        XCTAssertTrue(mockView.displayPlaceholderCalled)
        XCTAssertFalse(mockView.displayRecipeHistoryCalled)
    }

    func testPresentRecipeHistoryWithNonEmptyHistory() {
        let history: [HistoryItemDataModel] = [historyItem]

        presenter.presentRecipeHistory(history)

        XCTAssertTrue(mockView.displayRecipeHistoryCalled)
        XCTAssertFalse(mockView.displayPlaceholderCalled)
        XCTAssertEqual(mockView.receivedViewModel.count, 1)
        XCTAssertEqual(mockView.receivedViewModel.first?.mealName, historyItem.mealName)
    }

    func testPresentError() {
        let message = "Test error message"
        let error = NSError(domain: "test",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: message])

        presenter.presentError(error)

        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertEqual(mockView.receivedErrorMessage, message)
    }
}
