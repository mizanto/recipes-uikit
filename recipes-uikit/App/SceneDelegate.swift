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
        AppLogger.shared.info("Scene will connect to session: \(session.configuration.name ?? "unknown")", category: .ui)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        ValueTransformer.setValueTransformer(IngredientArrayTransformer(), forName: NSValueTransformerName("IngredientArrayTransformer"))
        
        window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        AppLogger.shared.info("Scene did disconnect", category: .ui)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        AppLogger.shared.info("Scene did become active", category: .ui)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        AppLogger.shared.info("Scene will resign active", category: .ui)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        AppLogger.shared.info("Scene will enter foreground", category: .ui)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppLogger.shared.info("Scene did enter background", category: .ui)
    }
}

