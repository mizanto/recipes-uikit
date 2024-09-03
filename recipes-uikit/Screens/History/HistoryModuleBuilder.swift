//
//  HistoryModuleBuilder.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

class HistoryModuleBuilder {
    static func build() -> UIViewController {
        let viewController = HistoryViewController()
        let presenter = HistoryPresenter(view: viewController)
        let interactor = HistoryInteractor(presenter: presenter)
        viewController.interactor = interactor
        return viewController
    }
}
