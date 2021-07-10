//
//  UIViewController+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UIViewController {
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
    
    static func getVisibleController(_ viewController: UIViewController? = UIViewController.rootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return self.getVisibleController(navigationController.visibleViewController)
        } else if let tabbarController = viewController as? UITabBarController {
            return self.getVisibleController(tabbarController.selectedViewController)
        } else if let presentedController = viewController?.presentedViewController {
            return self.getVisibleController(presentedController)
        } else {
            return viewController
        }
    }
    
}
