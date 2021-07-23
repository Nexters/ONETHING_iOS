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
        
        if self.haveNoToken(from: UserDefaultWrapper<String>(key: UserDefaultsKey.accessToken)) {
            self.presentLoginViewController(mainTabBarController)
        }
    }
    
    private func haveNoToken<T>(from userDefaultWrapper: UserDefaultWrapper<T>) -> Bool {
        return userDefaultWrapper.wrappedValue == nil
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
        guard let loginViewController =  UIStoryboard(name: StoryboardName.intro, bundle: nil).instantiateViewController(
            withIdentifier: LoginViewController.reuseIdentifier
        ) as? LoginViewController else { return nil }
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SocialManager.sharedInstance.handleSocialURLScheme(url)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

