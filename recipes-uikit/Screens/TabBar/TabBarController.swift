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

    override func viewDidLoad() {
        super.viewDidLoad()

        createRootControllers()
        setupTabItems()
        
        self.viewControllers = [
            UINavigationController(rootViewController: randomRecipeViewController),
            UINavigationController(rootViewController: historyViewController),
            UINavigationController(rootViewController: favoritesViewController)
        ]
        self.selectedIndex = 0
    }
    
    private func createRootControllers() {
        randomRecipeViewController = RecipeModuleBuilder.buildRandomRecipe()
        historyViewController = HistoryModuleBuilder.build()
        favoritesViewController = FavoritesModuleBuilder.build()
    }
    
    private func setupTabItems() {
        randomRecipeViewController.tabBarItem = UITabBarItem(
            title: "Random", image: UIImage(systemName: "shuffle"), tag: 0)
        historyViewController.tabBarItem = UITabBarItem(
            title: "History", image: UIImage(systemName: "clock"), tag: 1)
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
    }

}
