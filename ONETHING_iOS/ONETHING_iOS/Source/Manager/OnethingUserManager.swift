//
//  OnethingUserManager.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import UIKit

final class OnethingUserManager {
    
    static let sharedInstance = OnethingUserManager()
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasRefreshToken: Bool { return self.refreshToken != nil }
    
    func updateAuthToken(_ token: String, _ refreshToken: String) {
        self.accessToken = token
        self.refreshToken = refreshToken
    }
    
    @UserDefaultWrapper<String>(key: UserDefaultsKey.accessToken) private(set) var accessToken
    @UserDefaultWrapper<String>(key: UserDefaultsKey.refreshToken) private(set) var refreshToken
    
}
