//
//  AppDelegate.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppLogger.shared.info("Application did finish launching", category: .ui)
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configurationName = connectingSceneSession.configuration.name ?? "Unknown Configuration"
        AppLogger.shared.info("Configuring scene for connection: \(configurationName)", category: .ui)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        AppLogger.shared.info("Application did discard \(sceneSessions.count) scene session(s)", category: .ui)
    }
}

