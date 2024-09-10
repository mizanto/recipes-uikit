//
//  MockHistoryPresenter.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockHistoryPresenter: HistoryPresenterProtocol {
    var receivedHistory: [HistoryItemDataModel] = []
    var receivedError: Error?
    var presentRecipeHistoryCalled = false
    var presentErrorCalled = false
    
    func presentRecipeHistory(_ history: [HistoryItemDataModel]) {
        presentRecipeHistoryCalled = true
        receivedHistory = history
    }

    func presentError(_ error: Error) {
        presentErrorCalled = true
        receivedError = error
    }
}
