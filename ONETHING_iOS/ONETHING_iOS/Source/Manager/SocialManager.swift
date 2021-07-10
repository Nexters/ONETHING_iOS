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
    
    func setup() {
        KakaoSDKCommon.initSDK(appKey: SocialAccessType.kakao.appKey)
    }
    
    func handleSocialURLScheme(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) { _ = AuthController.handleOpenUrl(url: url) }
    }
    
    func login(type: SocialAccessType) {
        switch type {
        case .kakao: self.loginThroughKakao()
        case .apple: break
        }
    }
    
    private func loginThroughKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error != nil else { return }
                #warning("oauth Token 이용 우리 서버에 request")
                print(oauthToken?.accessToken)
                print(oauthToken?.refreshToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error != nil else { return }
                #warning("oauth Token 이용 우리 서버에 request")
                print(oauthToken?.accessToken)
                print(oauthToken?.refreshToken)
            }
        }
    }
    
    private init() { }
    
}
