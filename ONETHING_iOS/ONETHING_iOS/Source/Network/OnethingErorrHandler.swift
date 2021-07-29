//
//  ErorrHandler.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

final class OnethingErrorHandler {
    
    static let sharedInstance = OnethingErrorHandler()
    
    func handleError(_ error: OnethingError) {
        switch error {
        case .expiredAccessToken: self.handleExpiredAccessTokenError()
        case .expiredRefreshToken: self.handleExpiredRefreshTokenError()
        }
    }
    
    private func handleExpiredAccessTokenError() {
        
    }
    
    private func handleExpiredRefreshTokenError() {
        
    }
    
    private init() { }
    
}