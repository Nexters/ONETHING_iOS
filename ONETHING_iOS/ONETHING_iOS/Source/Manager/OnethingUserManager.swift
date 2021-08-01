//
//  OnethingUserManager.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

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
    
    func logout() {
        self.accessToken = nil
        self.refreshToken = nil
        self.doneHabitSetting = nil
    }
    
    // UserDefualt에 doneHabitSetting 값 보고 처음 습관 만들지 안만들지 페이지로 유도 (참고) - 로그인 떄는 처리되어 있음
    @UserDefaultWrapper<Bool>(key: UserDefaultsKey.doneHabitSetting) private(set) var doneHabitSetting
    @UserDefaultWrapper<String>(key: UserDefaultsKey.accessToken) private(set) var accessToken
    @UserDefaultWrapper<String>(key: UserDefaultsKey.refreshToken) private(set) var refreshToken
}
