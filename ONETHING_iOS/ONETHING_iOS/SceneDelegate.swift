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
        self.window?.rootViewController = mainTabBarController
        self.window?.makeKeyAndVisible()
        
        let userManager = OnethingUserManager.sharedInstance
        if !userManager.hasAccessToken {
            self.presentLoginViewController(mainTabBarController)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }

    private func presentLoginViewController(_ tabBarController: MainTabBarController) {
        guard let homeViewController = (tabBarController.children.first as? UINavigationController)?
                .viewControllers.first as? HomeViewController else { return }
        
        DispatchQueue.main.async {
            guard let navigationWithLoginViewController = self.navigationWithLoginViewController else { return }
            
            homeViewController.present(navigationWithLoginViewController, animated: false)
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

