//
//  BaseRecipeInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation
import UIKit

protocol RecipeInteractorProtocol: AnyObject {
    func fetchRecipe()
    func toggleFavoriteStatus()
}

class BaseRecipeInteractor: RecipeInteractorProtocol {
    internal let presenter: RecipePresenterProtocol
    internal let storageService: StorageServiceProtocol

    internal var currentRecipe: RecipeDataModel?

    enum InteractorError: Error, LocalizedError {
        case methodNotImplemented

        var errorDescription: String? {
            switch self {
            case .methodNotImplemented:
                return "This method must be overridden in a subclass."
            }
        }
    }

    init(presenter: RecipePresenterProtocol, storageService: StorageServiceProtocol) {
        self.presenter = presenter
        self.storageService = storageService
    }

    func fetchRecipe() {
        AppLogger.shared.error("fetchRecipe method is not implemented in subclass", category: .ui)
        presenter.presentError(InteractorError.methodNotImplemented)
    }

    func toggleFavoriteStatus() {
        guard let recipe = currentRecipe else {
            AppLogger.shared.error("No recipe available to toggle favorite status", category: .ui)
            presenter.presentError(StorageError.itemNotFound)
            return
        }

        do {
            if recipe.isFavorite {
                try storageService.removeRecipeFromFavorites(recipe)
                AppLogger.shared.info("Removed recipe from favorites: \(recipe.mealName)", category: .database)
            } else {
                try storageService.addRecipeToFavorites(recipe)
                AppLogger.shared.info("Added recipe to favorites: \(recipe.mealName)", category: .database)
            }
            currentRecipe?.isFavorite.toggle()

            if let currentRecipe = currentRecipe {
                presentRecipe(currentRecipe)
            }
        } catch {
            AppLogger.shared.error("Failed to toggle favorite status: \(error.localizedDescription)",
                                   category: .database)
            presenter.presentError(error)
        }
    }

    func presentRecipe(_ recipe: RecipeDataModel) {
        presenter.presentRecipe(
            recipe,
            onYoutubeButton: { [weak self] in
                self?.openURL(url: recipe.youtubeURL)
            },
            onSourceButton: { [weak self] in
                self?.openURL(url: recipe.sourceURL)
            })
    }

    func openURL(url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
}
