//
//  AppDependencyConfigurator.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 6.09.2024.
//

import UIKit

class AppDependencyConfigurator {

    static let shared = AppDependencyConfigurator()

    private init() {}

    private(set) var networkService: NetworkServiceProtocol!
    private(set) var storageService: StorageServiceProtocol!

    func configureDependencies() {
        networkService = NetworkService()
        storageService = StorageService()

        ValueTransformer.setValueTransformer(
            IngredientArrayTransformer(), forName: NSValueTransformerName("IngredientArrayTransformer"))
    }

    func configuredTabBarController() -> UITabBarController {
        let tabBarController = TabBarController(
            networkService: networkService,
            storageService: storageService
        )
        return tabBarController
    }
}
