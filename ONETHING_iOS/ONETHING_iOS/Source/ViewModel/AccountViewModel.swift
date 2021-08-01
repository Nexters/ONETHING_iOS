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
    
    let loadingSubject = PublishSubject<Bool>()
    let userRelay = BehaviorRelay<OnethingUserModel?>(value: nil)
    
    init(apiService: APIService<UserAPI> = APIService<UserAPI>()) {
        self.apiService = apiService
    }
    
    func requestUserInform() {
        self.loadingSubject.onNext(true)
        
        let accountAPI = UserAPI.account
        self.apiService.requestAndDecode(api: accountAPI, comepleteHandler: { [weak self] (userModel: OnethingUserModel) in
            guard let self = self else { return }
            self.loadingSubject.onNext(false)
            self.userRelay.accept(userModel)
        }, errorHandler: { [weak self] _ in
            self?.loadingSubject.onNext(false)
        })
    }
    
    func requestLogout() {
        guard let accessToken = OnethingUserManager.sharedInstance.accessToken else { return }
        guard let refreshToken = OnethingUserManager.sharedInstance.refreshToken else { return }
        
        self.loadingSubject.onNext(true)
        let logoutAPI = UserAPI.logout(accessToken: accessToken, refreshToken: refreshToken)
        self.apiService.requestAndDecode(api: logoutAPI, comepleteHandler: { [weak self] (isSuccess: Bool) in
            guard let self = self else { return }
            self.loadingSubject.onNext(false)
            
            if isSuccess {
                print("Success")
            } else {
                print("Failure")
            }
        })
    }
    
    private let apiService: APIService<UserAPI>
    private let disposeBag = DisposeBag()
    
}
