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
    
    typealias Completion = (LoginResponse) -> Void
    
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
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error == nil else { return }
                guard let oauthToken = oauthToken else { return }
                
                self.executeKakaoCompletion(usingOauthToken: oauthToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error == nil else { return }
                guard let oauthToken = oauthToken else { return }
                
                self.executeKakaoCompletion(usingOauthToken: oauthToken)
            }
        }
    }
    
    private func executeKakaoCompletion(usingOauthToken oauthToken: OAuthToken) {
        let response = LoginResponse.kakao(
            accessToken: oauthToken.accessToken,
            refreshToken: oauthToken.refreshToken,
            refreshExpiresIn: oauthToken.refreshTokenExpiresIn,
            scope: oauthToken.scope ?? ""
        )
        self.executeCompletion(response: response)
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
    
    private func executeCompletion(response: LoginResponse) {
        self.completion?(response)
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
        
        guard let decodedAuthorizationCode = String(data: authorizationCode, encoding: .utf8) else { return }
        guard let decodedIdentityToken = String(data: identityToken, encoding: .utf8)         else { return }
        
        var userFullName: String = ""
        if let appleUserName = appleIDCredential.fullName {
            if let givenName = appleUserName.givenName { userFullName += givenName }
            if let familyName = appleUserName.familyName { userFullName += familyName }
        }

        let response = LoginResponse.apple(
            authorizationCode: decodedAuthorizationCode,
            identityToken: decodedIdentityToken,
            userFullName: userFullName != "" ? userFullName : nil
        )
        self.executeCompletion(response: response)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}
    
}

extension SocialManager {
    
    enum LoginResponse {
        case apple(authorizationCode: String, identityToken: String, userFullName: String?)
        case kakao(accessToken: String, refreshToken: String, refreshExpiresIn: TimeInterval, scope: String)
    }
    
}
