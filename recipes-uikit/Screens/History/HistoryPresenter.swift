//
//  HistoryPresenter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

protocol HistoryPresenterProtocol {
    func presentRecipeHistory(_ history: [StoredRecipe])
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
    
    func presentRecipeHistory(_ history: [StoredRecipe]) {
        AppLogger.shared.info("Presenting recipe history with \(history.count) items", category: .ui)
        
        let viewModel = history.map { recipe in
            HistoryViewModel(
                mealName: recipe.mealName,
                dateAdded: dateFormatter.string(from: recipe.dateAdded)
            )
        }
        view?.displayRecipeHistory(viewModel)
    }
    
    func presentError(_ error: Error) {
        AppLogger.shared.error("Error presenting recipe history: \(error.localizedDescription)", category: .ui)
        view?.displayError(error.localizedDescription)
    }
}
