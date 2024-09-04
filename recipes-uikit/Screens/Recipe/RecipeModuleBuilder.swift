//
//  RecipeModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

final class RecipeModuleBuilder {
    
    static func buildRandomRecipe() -> UIViewController {
        let viewController = RecipeViewController(screenType: .random)
        let presenter = RecipePresenter(view: viewController)
        let interactor = RandomRecipeInteractor(presenter: presenter)
        viewController.interactor = interactor
        return viewController
    }
    
    static func buildDetail(recipeId: String) -> UIViewController {
        let viewController = RecipeViewController(screenType: .detail)
        let presenter = RecipePresenter(view: viewController)
        let interactor = RecipeDetailInteractor(presenter: presenter, recipeId: recipeId)
        viewController.interactor = interactor
        return viewController
    }
}
