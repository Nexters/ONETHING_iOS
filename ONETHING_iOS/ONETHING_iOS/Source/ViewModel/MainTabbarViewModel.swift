//
//  MainTabbarViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/07.
//

import Foundation

final class MainTabbarViewModel {
    
    func requestUserInformation() {
        let apiService = APIService<UserAPI>()
        let accountAPI = UserAPI.account
        
        apiService.requestAndDecode(api: accountAPI, comepleteHandler: { (userModel: OnethingUserModel) in
            OnethingUserManager.sharedInstance.setCurrentUser(userModel)
            
            // User 정보 Update되거나 설정된 경우 - Notification
            NotificationCenter.default.post(name: .didUpdateUserInform, object: nil)
        })
    }
    
}
