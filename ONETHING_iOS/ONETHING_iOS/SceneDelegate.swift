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
        self.window = UIWindow(windowScene: windowScene)
        let mainTabBarController = MainTabBarController()
        
//        let userManager = OnethingUserManager.sharedInstance
//        if !userManager.hasAccessToken {
//            self.presentLoginViewController(mainTabBarController)
//        }

        self.window?.rootViewController = mainTabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }

    private func presentLoginViewController(_ rootController: MainTabBarController) {
        DispatchQueue.main.async {
            guard let navigationWithLoginViewController = self.navigationWithLoginViewController else { return }
            rootController.present(navigationWithLoginViewController, animated: false)
        }
    }
    
    private var navigationWithLoginViewController: UINavigationController? {
        guard let loginViewController = LoginViewController.instantiateViewController(from: StoryboardName.intro) else { return nil }
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}

