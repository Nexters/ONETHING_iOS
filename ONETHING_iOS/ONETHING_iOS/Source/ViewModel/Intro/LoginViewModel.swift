//
//  LoginViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import Foundation
import RxSwift

final class LoginViewModel {
    
    let loadingSubject = BehaviorSubject<Bool>(value: false)
    let completeSubject = PublishSubject<Bool>()
    
    init(loginService: APIService<UserAPI> = APIService()) {
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
        
        self.loginService.requestAndDecode(api: appleLoginAPI, comepleteHandler: { [weak self] (loginResponseModel: LoginResponseModel) in
            defer { self?.loadingSubject.onNext(false) }
        
            guard let accessToken = loginResponseModel.token?.accessToken     else { return }
            guard let refreshToken = loginResponseModel.token?.refreshToken   else { return }
            guard let doneHabbitSetting = loginResponseModel.doneHabitSetting else { return }
            OnethingUserManager.sharedInstance.updateAuthToken(accessToken, refreshToken)
            OnethingUserManager.sharedInstance.updateDoneHabitSetting(doneHabbitSetting)
            self?.completeSubject.onNext(doneHabbitSetting)
        }, errorHandler: { [weak self] error in
            self?.loadingSubject.onNext(false)
        })
    }
    
    private func loginKakao() { }
    
    private let disposeBag = DisposeBag()
    
    private let loginService: APIService<UserAPI>
    
}
