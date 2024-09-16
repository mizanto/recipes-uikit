//
//  HistoryModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

final class HistoryModuleBuilder {
    static func build(storageService: StorageServiceProtocol) -> UIViewController {
        let viewController = HistoryViewController()
        let presenter = HistoryPresenter(view: viewController)
        let router = HistoryRouter(storageService: storageService, viewController: viewController)
        let interactor = HistoryInteractor(presenter: presenter,
                                           router: router,
                                           storageService: storageService)
        viewController.interactor = interactor
        return viewController
    }
}
