//
//  FavoritesModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

final class FavoritesModuleBuilder {
    static func build(storageService: StorageServiceProtocol) -> FavoritesViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter(view: view)
        let router = FavoritesRouter(storageService: storageService,
                                     viewController: view)
        let interactor = FavoritesInteractor(presenter: presenter,
                                             router: router,
                                             storageService: storageService)
        view.interactor = interactor
        return view
    }
}
