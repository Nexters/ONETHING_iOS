//
//  NavigationController+.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/10/14.
//

import UIKit

extension UINavigationController {
    func setupEnableSwipeBackMotion() {
        self.interactivePopGestureRecognizer?.delegate = nil
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func rootViewController<T: UIViewController>(type: T.Type) -> T? {
        return self.viewControllers.first as? T
    }
}
