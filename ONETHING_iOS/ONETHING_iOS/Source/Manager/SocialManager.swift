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

import AuthenticationServices

class SocialManager: NSObject {
    
    static let sharedInstance = SocialManager()
    
    func setup() {
        KakaoSDKCommon.initSDK(appKey: SocialAccessType.kakao.appKey)
    }
    
    func handleSocialURLScheme(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) { _ = AuthController.handleOpenUrl(url: url) }
    }
    
    func login(with type: SocialAccessType) {
        switch type {
        case .kakao: self.loginThroughKakao()
        case .apple: self.loginThroughApple()
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
    
    private func loginThroughApple() {
        let appleIDProvider          = ASAuthorizationAppleIDProvider()
        let appleRequest             = appleIDProvider.createRequest()
        appleRequest.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [appleRequest])
        controller.delegate                    = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private override init() {
        super.init()
    }
    
}

extension SocialManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })!
    }
    
}

extension SocialManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userIdentifier = appleIDCredential.user
        let userName       = appleIDCredential.fullName
        let userEmail      = appleIDCredential.email
        
        #warning("Apple 토큰으로 서버로 던지는 거 필요")
        print(appleIDCredential.identityToken)
        print(userIdentifier)
        print(userName)
        print(userEmail)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
