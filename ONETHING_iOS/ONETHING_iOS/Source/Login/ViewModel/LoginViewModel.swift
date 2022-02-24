//
//  LoginViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import Foundation
import RxSwift

final class LoginViewModel {
    
    typealias CompleteFlag = (doneHabit: Bool, isSettingNickname: Bool)
    
    let loadingSubject = BehaviorSubject<Bool>(value: false)
    let completeSubject = PublishSubject<CompleteFlag>()
    
    init(loginService: APIService = .shared) {
        self.loginService = loginService
    }
    
    func login(type: SocialAccessType) {
        self.loadingSubject.onNext(true)
        SocialManager.sharedInstance.login(with: type) { [weak self] response in
            switch response {
            case .kakao(let accessToken, let refreshToken, let refreshExpiresIn, let scope):
                self?.loginKakao(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    refreshExpiresIn: refreshExpiresIn,
                    scope: scope
                )
            case .apple(let authorizationCode, let identityToken, let userFullName):
                self?.loginApple(authorizationCode, identityToken, userFullName)
            }
        }
    }
    
    private func loginApple(_ authorizationCode: String, _ identityToken: String, _ userName: String? = nil) {
        let appleLoginAPI = UserAPI.appleLogin(
            authorizationCode: authorizationCode,
            identityToken: identityToken,
            userName: userName
        )
        
        self.loginService.requestAndDecodeRx(
            apiTarget: appleLoginAPI,
            retryHandler: { [weak self] in self?.loginApple(authorizationCode, identityToken, userName) }
        ).subscribe(onSuccess: { [weak self] (loginResponseModel: LoginResponseModel) in
            defer { self?.loadingSubject.onNext(false) }
            
            guard let accessToken = loginResponseModel.token?.accessToken     else { return }
            guard let refreshToken = loginResponseModel.token?.refreshToken   else { return }
            OnethingUserManager.sharedInstance.updateAuthToken(accessToken, refreshToken)
            
            OnethingUserManager.sharedInstance.requestAccount(completion: { [weak self] accountModel in
                self?.completeSubject.onNext((accountModel.doneHabitSetting == true,
                                              accountModel.account?.nickname != nil))
            })
        }, onFailure: { [weak self] _ in
            self?.loadingSubject.onNext(false)
        }).disposed(by: self.disposeBag)
    }
    
    private func loginKakao(accessToken: String, refreshToken: String, refreshExpiresIn: TimeInterval, scope: String) {
        
    }
    
    private let disposeBag = DisposeBag()
    
    private let loginService: APIService
    
}
