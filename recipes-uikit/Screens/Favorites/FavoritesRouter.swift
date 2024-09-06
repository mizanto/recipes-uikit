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
    
    let storageService: StorageServiceProtocol
    weak var viewController: UIViewController?
    
    init(storageService: StorageServiceProtocol, viewController: UIViewController) {
        self.storageService = storageService
        self.viewController = viewController
    }
    
    func navigateToRecipeDetail(with recipeId: String) {
        let recipeDetailViewController = RecipeModuleBuilder.buildDetail(
            storageService: storageService,
            recipeId: recipeId
        )
        
        viewController?.navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }
}
