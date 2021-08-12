//
//  AccountViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation
import RxSwift
import RxRelay

final class AccountViewModel {
    
    let logoutSuccessSubject = PublishSubject<Void>()
    let loadingSubject = PublishSubject<Bool>()
    let userRelay = BehaviorRelay<OnethingUserModel?>(value: nil)

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func requestUserInform() {
        self.loadingSubject.onNext(true)
        
        OnethingUserManager.sharedInstance.requestAccount { [weak self] user in
            self?.userRelay.accept(user)
            self?.loadingSubject.onNext(false)
        }
    }
    
    func requestLogout() {
        guard let accessToken = OnethingUserManager.sharedInstance.accessToken else { return }
        guard let refreshToken = OnethingUserManager.sharedInstance.refreshToken else { return }
        
        self.loadingSubject.onNext(true)
        let logoutAPI = UserAPI.logout(accessToken: accessToken, refreshToken: refreshToken)
        
        self.apiService.requestAndDecodeRx(apiTarget: logoutAPI, retryHandler: { [weak self] in
            self?.requestLogout()
        }).subscribe(onSuccess: { [weak self] (isSuccess: Bool) in
            guard let self = self else { return }
            self.loadingSubject.onNext(false)
            
            if isSuccess == true {
                OnethingUserManager.sharedInstance.logout()
                self.logoutSuccessSubject.onNext(())
            }
        }, onFailure: { [weak self] error in
            self?.loadingSubject.onNext(false)
        }).disposed(by: self.disposeBag)
    }
    
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
}
