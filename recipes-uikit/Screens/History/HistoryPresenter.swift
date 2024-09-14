//
//  HistoryPresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol HistoryPresenterProtocol {
    func presentRecipeHistory(_ history: [HistoryItemDataModel])
    func presentError(_ error: Error)
}

class HistoryPresenter: HistoryPresenterProtocol {

    weak var view: HistoryViewProtocol?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func presentRecipeHistory(_ history: [HistoryItemDataModel]) {
        AppLogger.shared.info("Presenting recipe history with \(history.count) items", category: .ui)

        if history.isEmpty {
            view?.displayPlaceholder()
        } else {
            let viewModel = history.map { item in
                HistoryViewModel(
                    id: item.id,
                    mealName: item.mealName,
                    dateAdded: dateFormatter.string(from: item.date)
                )
            }
            view?.displayRecipeHistory(viewModel)
        }
    }

    func presentError(_ error: Error) {
        AppLogger.shared.error("Error presenting recipe history: \(error.localizedDescription)", category: .ui)
        view?.displayError(error.localizedDescription)
    }
}
