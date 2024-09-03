//
//  RandomRecipeModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

final class RandomRecipeModuleBuilder {
    
    static func build() -> UIViewController {
        let viewController = RandomRecipeViewController()
        let presenter = RandomRecipePresenter(view: viewController)
        let interactor = RandomRecipeInteractor(presenter: presenter)
        viewController.interactor = interactor
        return viewController
    }
}
