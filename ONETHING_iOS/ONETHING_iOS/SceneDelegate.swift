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
        
        guard let goalSetting = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting) else { return }
        self.window?.rootViewController = goalSetting
        self.window?.makeKeyAndVisible()
//        let mainTabBarController = MainTabBarController()
//
//        let userManager = OnethingUserManager.sharedInstance
//        self.presentNavigationControllerIfNeeded(with: userManager, rootController: mainTabBarController)
//
//        self.window?.rootViewController = mainTabBarController
//        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }
    
    private func presentNavigationControllerIfNeeded(with userManager: OnethingUserManager, rootController: MainTabBarController) {
        if userManager.hasAccessToken == false {
            let loginViewController = self.navigationController(LoginViewController.instantiateViewController(from: .intro))
            self.present(viewController: loginViewController, with: rootController)
            return
        }
        
        if let doneHabitSetting = userManager.doneHabitSetting, doneHabitSetting == false {
            let goalSettingFirstViewController = self.navigationController(GoalSettingFirstViewController.instantiateViewController(from: .goalSetting))
            self.present(viewController: goalSettingFirstViewController, with: rootController)
            return
        }
    }

    private func present(viewController: UIViewController?, with rootController: MainTabBarController) {
        guard let viewController = viewController else { return }
        
        DispatchQueue.main.async {
            rootController.present(viewController, animated: false)
        }
    }
    
    private func navigationController(_ rootController: UIViewController?) -> UINavigationController? {
        guard let rootController = rootController else { return nil }
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}

