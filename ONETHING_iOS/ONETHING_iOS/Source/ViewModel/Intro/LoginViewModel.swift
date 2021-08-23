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
        SocialManager.sharedInstance.login(with: type) { [weak self] accessToken, refreshToken, userName in
            self?.loadingSubject.onNext(true)
            switch type {
            case .apple: self?.loginApple(accessToken, refreshToken, userName)
            case .kakao: self?.loginKakao()
            }
        }
    }
    
    private func loginApple(_ authorizationCode: String?, _ identityToken: String?, _ userName: String? = nil) {
        guard let authorizationCode = authorizationCode else { return }
        guard let identityToken = identityToken         else { return }
        
        let appleLoginAPI = UserAPI.appleLogin(authorizationCode: authorizationCode,
                                               identityToken: identityToken,
                                               userName: userName)
        
        self.loginService.requestAndDecodeRx(
            apiTarget: appleLoginAPI, retryHandler: { [weak self] in
            self?.loginApple(authorizationCode, identityToken, userName)}
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
    
    private func loginKakao() { }
    
    private let disposeBag = DisposeBag()
    
    private let loginService: APIService
    
}
