//
//  SceneDelegate.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = TabBarController()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

