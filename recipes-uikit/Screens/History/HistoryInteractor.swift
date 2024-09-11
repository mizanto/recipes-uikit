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
         storageService: StorageServiceProtocol) {
        self.presenter = presenter
        self.storageService = storageService
    }

    func fetchHistory() {
        AppLogger.shared.info("Fetching recipe history from storage", category: .database)

        do {
            let history = try storageService.getRecipeHistory()

            AppLogger.shared.info("Fetched \(history.count) history items", category: .database)
            presenter.presentRecipeHistory(history)
        } catch {
            AppLogger.shared.error("Failed to fetch recipe history: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }

    func clearHistory() {
        AppLogger.shared.info("Clearing recipe history", category: .database)

        do {
            try storageService.clearHistory()
            AppLogger.shared.info("History cleared successfully", category: .database)
            presenter.presentRecipeHistory([])
        } catch {
            AppLogger.shared.error("Failed to clear history: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
}
