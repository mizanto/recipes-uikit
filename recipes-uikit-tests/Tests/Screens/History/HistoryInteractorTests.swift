//
//  HistoryInteractorTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class HistoryInteractorTests: XCTestCase {
    var interactor: HistoryInteractor!
    var mockPresenter: MockHistoryPresenter!
    var mockRouter: MockHistoryRouter!
    var mockStorageService: MockStorageService!
    var historyItem: HistoryItemDataModel!

    override func setUp() {
        super.setUp()
        
        mockPresenter = MockHistoryPresenter()
        mockRouter = MockHistoryRouter()
        mockStorageService = MockStorageService()
        interactor = HistoryInteractor(presenter: mockPresenter,
                                       router: mockRouter,
                                       storageService: mockStorageService)
        historyItem = HistoryItemDataModel(id: "1",
                                           mealName: "Spaghetti",
                                           date: Date())
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageService = nil
        historyItem = nil
        
        super.tearDown()
    }

    func testFetchHistorySuccess() {
        mockStorageService.history = [historyItem]

        interactor.fetchHistory()

        XCTAssertTrue(mockPresenter.presentRecipeHistoryCalled)
        XCTAssertEqual(mockPresenter.receivedHistory.count, 1)
        XCTAssertEqual(mockPresenter.receivedHistory.first?.mealName, "Spaghetti")
    }

    func testFetchHistoryFailure() {
        mockStorageService.error = StorageError.itemNotFound

        interactor.fetchHistory()

        XCTAssertTrue(mockPresenter.presentErrorCalled)
        XCTAssertNotNil(mockPresenter.receivedError)
        XCTAssertEqual(mockPresenter.receivedError as? StorageError, StorageError.itemNotFound)
    }

    func testClearHistorySuccess() {
        mockStorageService.history = [historyItem]
        
        interactor.clearHistory()

        XCTAssertTrue(mockPresenter.presentRecipeHistoryCalled)
        XCTAssertEqual(mockPresenter.receivedHistory.count, 0)
    }

    func testClearHistoryFailure() {
        mockStorageService.error = StorageError.failedToDelete

        interactor.clearHistory()

        XCTAssertTrue(mockPresenter.presentErrorCalled)
        XCTAssertNotNil(mockPresenter.receivedError)
        XCTAssertEqual(mockPresenter.receivedError as? StorageError, StorageError.failedToDelete)
    }
    
    func testSelectRecipeCallsRouter() {
        interactor.selectRecipe(withId: "1")
        
        XCTAssertTrue(mockRouter.navigateToRecipeDetailCalled)
        XCTAssertEqual(mockRouter.selectedRecipeId, "1")
    }
}
