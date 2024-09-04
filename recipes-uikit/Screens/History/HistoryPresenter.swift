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
        let viewModel = history.map { recipe in
            HistoryViewModel(
                mealName: recipe.mealName,
                dateAdded: dateFormatter.string(from: recipe.dateAdded)
            )
        }
        view?.displayRecipeHistory(viewModel)
    }
    
    func presentError(_ error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
