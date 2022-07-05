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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene).then {
            $0.overrideUserInterfaceStyle = .light
        }

        self.window?.rootViewController = self.splashViewController
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }
    
    private var splashViewController: SplashViewController? {
        guard let splashViewController = SplashViewController.instantiateViewController(from: .intro)
        else { return nil }
        
        splashViewController.delegate = self
        return splashViewController
    }
}

extension SceneDelegate: SplashViewControllerDelegate {
    func splashViewController(_ viewController: SplashViewController, didOccur event: SplashViewController.Event) {
        if event == .splashAnimationDidFinish {
            self.changeRootToMainTabBarController()
        }
    }
    
    private func changeRootToMainTabBarController() {
        self.window?.rootViewController = MainTabBarController()
        self.window?.makeKeyAndVisible()
    }
}
