//
//  MainTabBarController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import Lottie
import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.setupViewControllers()
        self.setupUserInformIfNeeded()
        
        DispatchQueue.main.async {
            self.decideStartController()
        }
    }
    
    func processLogout() {
        guard let loginViewController = LoginViewController.instantiateViewController(from: .intro) else { return }
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        self.present(navigationController, animated: true) { [weak self] in
            guard let self = self else { return }
            self.selectedIndex = 0
            self.moveToRoot()
            self.clearChildControllers()
        }
    }
    
    func broadCastRequiredReload() {
        self.setupUserInformIfNeeded()
        self.viewControllers?.forEach { viewController in
            guard let navigationController = viewController as? UINavigationController else { return }
            guard let topController = navigationController.topViewController           else { return }
            guard let baseController = topController as? BaseViewController            else { return }
            guard baseController.isViewLoaded == true                                  else { return }
            baseController.reloadContentsIfRequired()
        }
    }
    
    private func moveToRoot() {
        guard let viewControllers = self.viewControllers else { return }
        viewControllers.forEach { viewController in
            guard let navigationController = viewController as? UINavigationController else { return }
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    private func clearChildControllers() {
        guard let viewControllers = self.viewControllers else { return }
        viewControllers.forEach { viewController in
            guard let navigationController = viewController as? UINavigationController else { return }
            guard let topController = navigationController.topViewController           else { return }
            guard let baseController = topController as? BaseViewController            else { return }
            guard baseController.isViewLoaded == true                                  else { return }
            baseController.clearContents()
        }
    }
    
    private func setupTabBar() {
        if #available(iOS 15.0, *) {
            self.setupTabBarBackgroundForiOS15Above()
        } else {
            self.setupTabBarBackgroundForiOS14Below()
        }
        
        self.tabBar.layer.applyShadow(x: 0, y: 0, blur: 30.0)
        self.tabBar.tintColor = .black_100
    }
    
    private func setupTabBarBackgroundForiOS14Below() {
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
    
    @available(iOS 15.0, *)
    private func setupTabBarBackgroundForiOS15Above() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViewControllers() {
        self.viewControllers = Child.allCases.map {
            $0.createController()
        }
    }
    
    private func setupUserInformIfNeeded() {
        guard OnethingUserManager.sharedInstance.hasAccessToken == true else { return }
        self.viewModel.requestUserInformation()
    }
    
    private let viewModel = MainTabbarViewModel()
}

extension MainTabBarController {
    
    enum Child: CaseIterable {
        case home
        case myhabit
        case mypage
        
        var tabbarImage: UIImage? {
            switch self {
            case .home:     return UIImage(named: "home_inactive")
            case .myhabit:  return UIImage(named: "history_inactive")
            case .mypage:   return UIImage(named: "mypage_inactive")
            }
        }
        
        func createController() -> UIViewController {
            var childController: UIViewController
            switch self {
            case .home:
                childController = HomeViewController()
            case .myhabit:
                childController = MyHabitViewController()
            case .mypage:
                childController = ProfileViewController.instantiateViewController(from: .profile) ?? ProfileViewController()
            }
            
            let navigationController = UINavigationController(rootViewController: childController)
            navigationController.tabBarItem.image = self.tabbarImage
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
    }
    
}
