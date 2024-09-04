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
        let interactor = FavoritesInteractor(presenter: presenter)
        view.interactor = interactor
        return view
    }
}
