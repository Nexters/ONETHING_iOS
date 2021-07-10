//
//  SocialManager.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

class SocialManager {
    
    static let sharedInstance = SocialManager()
    
    private init() { }
    
    func setup() {
        KakaoSDKCommon.initSDK(appKey: SocialAccessType.kakao.appKey)
    }
    
    func login(type: SocialAccessType) {
        switch type {
        case .kakao: self.loginThroughKakao()
        case .apple: break
        }
    }
    
    private func loginThroughKakao() {
        UserApi.shared.loginWithKakaoAccount { authToken, error in
            
        }
        
        UserApi.shared.loginWithKakaoAccount { authToken, error in
            authToken.
        }
    }
    
}

extension SocialManager {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) { return AuthController.handleOpenUrl(url: url, options: options) }
        return false
    }
    
}
