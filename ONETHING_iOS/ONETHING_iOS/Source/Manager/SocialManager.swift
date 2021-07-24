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
    
    typealias Completion = () -> Void
    
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
                #warning("oauth Token 이용 우리 서버에 request")
                print(oauthToken?.accessToken)
                print(oauthToken?.refreshToken)
                
                self.excuteCompletion()
            }
        } else {
            KakaoSDKUser.UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error != nil else { return }
                #warning("oauth Token 이용 우리 서버에 request")
                print(oauthToken?.accessToken)
                print(oauthToken?.refreshToken)
                
                self.excuteCompletion()
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
    
    private func excuteCompletion() {
        self.completion?()
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
        
        let userIdentifier = appleIDCredential.user
        let userName       = appleIDCredential.fullName
        let userEmail      = appleIDCredential.email
        
        #warning("Apple 토큰으로 서버로 던지는 거 필요")
        guard let identityToken = appleIDCredential.identityToken         else { return }
        guard let authorizationCode = appleIDCredential.authorizationCode else { return }
        print(String(data: identityToken, encoding: .utf8))
        print(String(data: authorizationCode, encoding: .utf8))
        
        self.excuteCompletion()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #warning("에러에 대한 처리 필요")
        print(error.localizedDescription)
    }
    
}
