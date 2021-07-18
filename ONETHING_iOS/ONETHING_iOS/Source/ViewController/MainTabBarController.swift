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
        self.configureViewControllers()
    }
    
    private func configureViewControllers() {
        self.viewControllers = [
            createNavigationController(for: HomeViewController(), image: UIImage(systemName: "house")!),
            createNavigationController(for: HistoryViewController(), image: UIImage(systemName: "folder")!),
            createNavigationController(for: ProfileViewController(), image: UIImage(systemName: "person.circle")!)
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
