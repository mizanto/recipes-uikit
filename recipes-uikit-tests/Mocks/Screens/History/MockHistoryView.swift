//
//  MockHistoryView.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockHistoryView: HistoryViewProtocol {
    var displayRecipeHistoryCalled = false
    var displayPlaceholderCalled = false
    var displayErrorCalled = false
    
    var receivedViewModel: [HistoryViewModel] = []
    var receivedErrorMessage: String?
    
    func displayRecipeHistory(_ viewModel: [HistoryViewModel]) {
        displayRecipeHistoryCalled = true
        receivedViewModel = viewModel
    }
    
    func displayPlaceholder() {
        displayPlaceholderCalled = true
    }
    
    func displayError(_ message: String) {
        displayErrorCalled = true
        receivedErrorMessage = message
    }
}
