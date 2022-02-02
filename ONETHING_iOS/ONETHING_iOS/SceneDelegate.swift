//
//  SceneDelegate.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        OnethingUserManager.sharedInstance.updateAuthToken("eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE2NDU0NzM1ODh9.kKg0XAIlmOLzslYDwlt7anm2-esE7qu-7SqrFw5fcsMMNVc5IkTa0Z9eD83aOVZVxfLq5HQPrgy9jJMBkH-fJw", "")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene).then {
            $0.overrideUserInterfaceStyle = .light
        }

        self.window?.rootViewController = MainTabBarController()
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }
    
}

