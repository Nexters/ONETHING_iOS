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

final class SocialManager: NSObject {
    
    typealias Completion = (String?, String?, String?) -> Void
    
    static let sharedInstance = SocialManager()
    
    func setup() {
        KakaoSDKCommon.initSDK(appKey: SocialAccessType.kakao.appKey)
    }
    
    func handleSocialURLScheme(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) { _ = AuthController.handleOpenUrl(url: url) }
    }
    
    func login(with type: SocialAccessType, completion: Completion? = nil) {
        self.completion = completion
        
        switch type {
        case .kakao: self.loginThroughKakao()
        case .apple: self.loginThroughApple()
        }
    }
    
    private func loginThroughKakao() {
        if KakaoSDKUser.UserApi.isKakaoTalkLoginAvailable() {
            KakaoSDKUser.UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error != nil else { return }
                self.excuteCompletion(oauthToken?.accessToken, oauthToken?.refreshToken, nil)
            }
        } else {
            KakaoSDKUser.UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error != nil else { return }
                self.excuteCompletion(oauthToken?.accessToken, oauthToken?.refreshToken, nil)
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
    
    private func excuteCompletion(_ accessToken: String?, _ refreshToken: String?, _ name: String?) {
        self.completion?(accessToken, refreshToken, name)
        self.completion = nil
    }
    
    private override init() {
        super.init()
    }
    
    private var completion: Completion?
    
}

extension SocialManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })!
    }
    
}

extension SocialManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        guard let identityToken = appleIDCredential.identityToken         else { return }
        guard let authorizationCode = appleIDCredential.authorizationCode else { return }
        
        let decodedAuthorizationCode = String(data: authorizationCode, encoding: .utf8)
        let decodedIdentityToken = String(data: identityToken, encoding: .utf8)
        
        var userFullName: String? = nil
        if let appleUserName = appleIDCredential.fullName {
            var finalFullName: String = ""
            if let givenName = appleUserName.givenName { finalFullName += givenName }
            if let familyName = appleUserName.familyName { finalFullName += familyName }
            
            if finalFullName != "" { userFullName = finalFullName }
        }

        self.excuteCompletion(decodedAuthorizationCode, decodedIdentityToken, userFullName)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #warning("에러에 대한 처리 필요")
        print(error.localizedDescription)
    }
    
}
