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
    
    func updateAuthToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func updateDoneHabitSetting(_ doneHabitSetting: Bool) {
        self.doneHabitSetting = doneHabitSetting
    }
    
    func setCurrentUser(_ currentUser: OnethingUserModel) {
        self.currentUser = currentUser
    }
    
    func logout() {
        self.accessToken = nil
        self.refreshToken = nil
        self.doneHabitSetting = nil
        self.currentUser = nil
    }
    
    func requestAccessTokenUsingRefreshToken() {
        guard let accessToken = self.accessToken   else { return }
        guard let refreshToken = self.refreshToken else { return }
        
        let refreshAPI = UserAPI.refresh(accessToken: accessToken, refreshToken: refreshToken)
        APIService<UserAPI>.requestAndDecodeRx(apiTarget: refreshAPI).subscribe(onSuccess: { (tokenResponseModel: TokenResponseModel) in
            guard let accessToken = tokenResponseModel.accessToken   else { return }
            guard let refreshToken = tokenResponseModel.refreshToken else { return }
            
            self.updateAuthToken(accessToken, refreshToken)
        }).disposed(by: self.disposeBag)
    }
    
    func requestAccount(completion: @escaping (OnethingUserModel) -> Void) {
        let accountAPI = UserAPI.account
        APIService<UserAPI>.requestAndDecodeRx(apiTarget: accountAPI, retryHandler: { [weak self] in
            self?.requestAccount(completion: completion)
        }).subscribe(onSuccess: { [weak self] (userModel: OnethingUserModel) in
            self?.setCurrentUser(userModel)
            NotificationCenter.default.post(name: .didUpdateUserInform, object: nil)
            completion(userModel)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private(set) var currentUser: OnethingUserModel?
    
    // UserDefualt에 doneHabitSetting 값 보고 처음 습관 만들지 안만들지 페이지로 유도 (참고) - 로그인 떄는 처리되어 있음
    @UserDefaultWrapper<Bool>(key: UserDefaultsKey.doneHabitSetting) private(set) var doneHabitSetting
    @UserDefaultWrapper<String>(key: UserDefaultsKey.accessToken) private(set) var accessToken
    @UserDefaultWrapper<String>(key: UserDefaultsKey.refreshToken) private(set) var refreshToken
}
