//
//  FavoritesModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

final class FavoritesModuleBuilder {
    static func build() -> FavoritesViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter(view: view)
        let router = FavoritesRouter()
        router.viewController = view
        let interactor = FavoritesInteractor()
        interactor.presenter = presenter
        interactor.router = router
        view.interactor = interactor
        return view
    }
}
