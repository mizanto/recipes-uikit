//
//  FavoritesRouter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import UIKit

protocol FavoritesRouterProtocol {
    func navigateToRecipeDetail(with recipeId: String)
}

class FavoritesRouter: FavoritesRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToRecipeDetail(with recipeId: String) {
        let recipeDetailViewController = RecipeModuleBuilder.buildDetail(recipeId: recipeId)
        
        viewController?.navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }
}
