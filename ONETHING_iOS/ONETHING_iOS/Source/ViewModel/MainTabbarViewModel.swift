//
//  MainTabbarViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/07.
//

import Foundation
import RxSwift

final class MainTabbarViewModel {
    
    func requestUserInformation() {
        let accountAPI = UserAPI.account
        
        APIService<UserAPI>.requestRx(apiTarget: accountAPI).subscribe(onSuccess: { (userModel: OnethingUserModel) in
            OnethingUserManager.sharedInstance.setCurrentUser(userModel)
            // User 정보 Update되거나 설정된 경우 - Notification
            NotificationCenter.default.post(name: .didUpdateUserInform, object: nil)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
}
