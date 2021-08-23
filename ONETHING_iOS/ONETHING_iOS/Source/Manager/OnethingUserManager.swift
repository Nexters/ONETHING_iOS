//
//  OnethingUserManager.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import RxSwift
import UIKit

final class OnethingUserManager {
    
    static let sharedInstance = OnethingUserManager()
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasRefreshToken: Bool { return self.refreshToken != nil }
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func updateAuthToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func setCurrentUser(_ currentUser: OnethingAccountModel) {
        self.currentUser = currentUser
    }
    
    func updateUser(_ userModel: OnethingUserModel) {
        self.currentUser?.updateUserModel(userModel)
        NotificationCenter.default.post(name: .didUpdateUserInform, object: nil)
    }
    
    func clearUserInform() {
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
    }
    
    func requestAccessTokenUsingRefreshToken() {
        guard let accessToken = self.accessToken   else { return }
        guard let refreshToken = self.refreshToken else { return }
        
        let refreshAPI = UserAPI.refresh(accessToken: accessToken, refreshToken: refreshToken)
        self.apiService.requestAndDecodeRx(apiTarget: refreshAPI).subscribe(onSuccess: { (tokenResponseModel: TokenResponseModel) in
            guard let accessToken = tokenResponseModel.accessToken   else { return }
            guard let refreshToken = tokenResponseModel.refreshToken else { return }
            
            self.updateAuthToken(accessToken, refreshToken)
        }).disposed(by: self.disposeBag)
    }
    
    func requestAccount(completion: @escaping (OnethingAccountModel) -> Void) {
        let accountAPI = UserAPI.account
        self.apiService.requestAndDecodeRx(apiTarget: accountAPI, retryHandler: { [weak self] in
            self?.requestAccount(completion: completion)
        }).subscribe(onSuccess: { [weak self] (accountModel: OnethingAccountModel) in
            self?.setCurrentUser(accountModel)
            NotificationCenter.default.post(name: .didUpdateUserInform, object: nil)
            completion(accountModel)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    
    private(set) var currentUser: OnethingAccountModel?
    
    @UserDefaultWrapper<String>(key: UserDefaultsKey.accessToken) private(set) var accessToken
    @UserDefaultWrapper<String>(key: UserDefaultsKey.refreshToken) private(set) var refreshToken
    
}
