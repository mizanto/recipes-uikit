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
    
    init(view: HistoryViewProtocol) {
        self.view = view
    }
    
    func presentRecipeHistory(_ history: [StoredRecipe]) {
        let viewModel = history.map { recipe in
            HistoryViewModel(
                mealName: recipe.mealName,
                isFavorite: false // TODO: add check logic
            )
        }
        view?.displayRecipeHistory(viewModel)
    }
    
    func presentError(_ error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
