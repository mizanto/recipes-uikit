//
//  RecipeDetailInteractor.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

class RecipeDetailInteractor: BaseRecipeInteractor {
    private let recipeId: String

    init(presenter: RecipePresenterProtocol, storageService: StorageServiceProtocol, recipeId: String) {
        self.recipeId = recipeId
        super.init(presenter: presenter, storageService: storageService)
    }

    override func fetchRecipe() {
        AppLogger.shared.info("Fetching recipe with ID: \(recipeId)", category: .database)
        do {
            let recipe = try storageService.getRecipe(by: recipeId)
            currentRecipe = recipe
            AppLogger.shared.info("Loaded recipe from storage: \(recipe.mealName)", category: .database)

            presenter.presentRecipe(recipe)
        } catch {
            AppLogger.shared.error("Failed to fetch recipe: \(error.localizedDescription)", category: .database)
            presenter.presentError(error)
        }
    }
}
