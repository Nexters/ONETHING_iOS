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

        let userManager = OnethingUserManager.sharedInstance
        self.presentNavigationControllerIfNeeded(with: userManager, rootController: mainTabBarController)

        self.window?.rootViewController = mainTabBarController
        self.window?.makeKeyAndVisible()
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
        
        OnethingUserManager.sharedInstance.requestAccount(completion: { accountModel in
            guard accountModel.doneHabitSetting == false else { return }
            
            let goalSettingFirstViewController = self.navigationController(GoalSettingFirstViewController.instantiateViewController(from: .goalSetting))
            self.present(viewController: goalSettingFirstViewController, with: rootController) {
                guard accountModel.account?.nickname == nil else { return }
                
                let viewController = ProfileSettingViewController.instantiateViewController(from: .intro)
                guard let profileSettingController = viewController else { return }
                profileSettingController.modalPresentationStyle = .fullScreen
                rootController.present(profileSettingController, animated: false, completion: nil)
            }
        })
    }

    private func present(viewController: UIViewController?, with rootController: MainTabBarController, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        
        DispatchQueue.main.async {
            rootController.present(viewController, animated: false, completion: completion)
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

