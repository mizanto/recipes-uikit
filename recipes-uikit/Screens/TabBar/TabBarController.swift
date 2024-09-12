//
//  TabBarController.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

class TabBarController: UITabBarController {

    private var randomRecipeViewController: UIViewController!
    private var historyViewController: UIViewController!
    private var favoritesViewController: FavoritesViewController!

    init(networkService: NetworkServiceProtocol,
         storageService: StorageServiceProtocol) {

        randomRecipeViewController = RecipeModuleBuilder.buildRandomRecipe(
            networkService: networkService,
            storageService: storageService
        )

        historyViewController = HistoryModuleBuilder.build(
            storageService: storageService
        )

        favoritesViewController = FavoritesModuleBuilder.build(
            storageService: storageService
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabItems()

        self.viewControllers = [
            UINavigationController(rootViewController: randomRecipeViewController),
            UINavigationController(rootViewController: historyViewController),
            UINavigationController(rootViewController: favoritesViewController)
        ]
        self.selectedIndex = 0
    }

    private func setupTabItems() {
        let randomRecipeTabBarItem = UITabBarItem(
            title: NSLocalizedString("random_tab.title", comment: ""),
            image: UIImage(systemName: "shuffle"),
            tag: 0
        )
        randomRecipeTabBarItem.accessibilityIdentifier = "RandomTab"
        randomRecipeViewController.tabBarItem = randomRecipeTabBarItem

        let historyTabBarItem = UITabBarItem(
            title: NSLocalizedString("history_tab.title", comment: ""),
            image: UIImage(systemName: "clock"),
            tag: 1
        )
        historyTabBarItem.accessibilityIdentifier = "HistoryTab"
        historyViewController.tabBarItem = historyTabBarItem

        let favoritesTabBarItem = UITabBarItem(
            title: NSLocalizedString("favorites_tab.title", comment: ""),
            image: UIImage(systemName: "star"),
            tag: 2
        )
        favoritesTabBarItem.accessibilityIdentifier =  "FavoritesTab"
        favoritesViewController.tabBarItem = favoritesTabBarItem
    }

}
