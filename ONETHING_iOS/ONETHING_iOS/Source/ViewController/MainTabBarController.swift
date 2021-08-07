//
//  MainTabBarController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .black_100
        
        self.setupViewControllers()
    }
    
    func broadCastRequiredReload() {
        self.viewControllers?.forEach { viewController in
            guard let navigationController = viewController as? UINavigationController else { return }
            guard let topController = navigationController.topViewController           else { return }
            guard let baseController = topController as? BaseViewController            else { return }
            guard baseController.isViewLoaded == true                                  else { return }
            baseController.reloadContentsIfRequired()
        }
    }
    
    private func setupViewControllers() {
        guard let profileController = ProfileViewController.instantiateViewController(from: .profile) else { return }
        self.viewControllers = [
            createNavigationController(
                for: HomeViewController(),
                image: UIImage(named: "home_inactive")!
            ),
            createNavigationController(
                for: HistoryViewController(),
                image: UIImage(named: "history_inactive")!
            ),
            createNavigationController(
                for: profileController,
                image: UIImage(named: "mypage_inactive")!
            )
        ]
    }
    
    private func createNavigationController(
        for rootViewController: UIViewController,
        title: String = "",
        image: UIImage
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
}
