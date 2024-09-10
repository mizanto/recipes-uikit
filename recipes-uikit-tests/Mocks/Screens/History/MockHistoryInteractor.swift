//
//  MockHistoryInteractor.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockHistoryInteractor: HistoryInteractorProtocol {
    var fetchHistoryCalled = false
    var clearHistoryCalled = false

    func fetchHistory() {
        fetchHistoryCalled = true
    }

    func clearHistory() {
        clearHistoryCalled = true
    }
}
