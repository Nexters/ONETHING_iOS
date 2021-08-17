//
//  ErorrHandler.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import UIKit

final class OnethingErrorHandler {
    
    static let sharedInstance = OnethingErrorHandler()
    
    func handleError(_ error: OnethingError) {
        switch error {
        case .expiredAccessToken:  self.handleExpiredAccessTokenError()
        case .expiredRefreshToken: self.handleExpiredRefreshTokenError()
        }
    }
    
    private func handleExpiredAccessTokenError() {
        OnethingUserManager.sharedInstance.requestAccessTokenUsingRefreshToken()
    }
    
    private func handleExpiredRefreshTokenError() {
        guard let rootViewController = UIViewController.rootViewController           else { return }
        guard let mainTabbarController = rootViewController as? MainTabBarController else { return }
        
        OnethingUserManager.sharedInstance.clearUserInform()
        mainTabbarController.processLogout()
    }
    
    private init() { }
    
}
