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
    
    static func instantiateViewController(from storyboard: Storyboard) -> Self? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? Self
    }
    
    static func navigationController(_ rootController: UIViewController?) -> UINavigationController? {
        guard let rootController = rootController else { return nil }
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    @objc func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func animateWithKeyboard(_ notification: NSNotification, animation: (CGRect?, Double?) -> Void) {
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrame = (notification.userInfo?[frameKey] as? NSValue)?.cgRectValue
        
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let keyboardDuration = notification.userInfo?[durationKey] as? Double
        
        animation(keyboardFrame, keyboardDuration)
    }
    
}
