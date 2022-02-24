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
    
    init(loginRepository: LoginRepository = LoginRepositoryImpl()) {
        self.loginRepository = loginRepository
    }
    
    func login(type: SocialAccessType) {
        self.loadingSubject.onNext(true)
        SocialManager.sharedInstance.login(with: type) { [weak self] response in
            switch response {
            case .kakao(let response):
                self?.loginKakao(requestBody: response)
            case .apple(let response):
                self?.loginApple(requestBody: response)
            }
        }
    }
    
    private func loginApple(requestBody: AppleLoginRequestBody) {
        self.loginRepository.requestAppleLogin(
            requestBody: requestBody,
            retryHandler: { [weak self] in
                self?.loginApple(requestBody: requestBody)
            })
            .withUnretained(self)
            .subscribe(onNext: { owner, loginResponseModel in
                owner.loadingSubject.onNext(false)
                owner.handleAfterLogin(loginResponse: loginResponseModel)
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func loginKakao(requestBody: KakaoLoginReqeustBody) {
        self.loginRepository.reqeustKakaoLogin(
            requestBody: requestBody,
            retryHandler: { [weak self] in
                self?.loginKakao(requestBody: requestBody)
            })
            .withUnretained(self)
            .subscribe(onNext: { owner, loginResponseModel in
                owner.loadingSubject.onNext(false)
                owner.handleAfterLogin(loginResponse: loginResponseModel)
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func handleAfterLogin(loginResponse: LoginResponseModel) {
        guard let accessToken = loginResponse.token?.accessToken   else { return }
        guard let refreshToken = loginResponse.token?.refreshToken else { return }
        
        OnethingUserManager.sharedInstance.updateAuthToken(accessToken, refreshToken)
        OnethingUserManager.sharedInstance.requestAccount(completion: { [weak self] accountModel in
            self?.completeSubject.onNext((accountModel.doneHabitSetting == true,
                                          accountModel.account?.nickname != nil))
        })
    }
    
    private let disposeBag = DisposeBag()
    
    private let loginRepository: LoginRepository
    
}
