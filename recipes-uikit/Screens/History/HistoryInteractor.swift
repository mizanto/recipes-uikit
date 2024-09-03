//
//  HistoryInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol HistoryInteractorProtocol {
    func fetchHistory()
    func clearHistory()
}

class HistoryInteractor: HistoryInteractorProtocol {
    private let presenter: HistoryPresenterProtocol
    private let storageService: StorageServiceProtocol
    
    init(presenter: HistoryPresenterProtocol,
         storageService: StorageServiceProtocol = StorageService()) {
        self.presenter = presenter
        self.storageService = storageService
    }
    
    func fetchHistory() {
        let history = storageService.loadRecipeHistory()
        presenter.presentRecipeHistory(history)
    }
    
    func clearHistory() {
        storageService.clearHistory()
        presenter.presentRecipeHistory([])
    }
}
