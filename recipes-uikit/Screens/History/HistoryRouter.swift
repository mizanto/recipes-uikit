//
//  HistoryRouter.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 13.09.2024.
//

import UIKit

protocol HistoryRouterProtocol {
    func navigateToRecipeDetail(with recipeId: String)
}

final class HistoryRouter: HistoryRouterProtocol {

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
