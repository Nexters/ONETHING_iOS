//
//  MainTabBarController+Launch.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/27.
//

import Lottie
import UIKit

extension MainTabBarController {
    
    func decideStartController() {
        if OnethingUserManager.sharedInstance.hasAccessToken == false {
//            guard let loginViewController = LoginViewController.instantiateViewController(from: .intro) else { return }
//            guard let navigationController = UIViewController.navigationController(loginViewController) else { return }
//            self.present(navigationController, animated: false)
            return
        }
        
        OnethingUserManager.sharedInstance.requestAccount { accountModel in
            guard accountModel.doneHabitSetting == false else { return }
            
            let goalSettingController = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting)
            guard let navigationController = UIViewController.navigationController(goalSettingController) else { return }
            self.present(navigationController, animated: false) {
                guard accountModel.account?.nickname == nil else { return }
                
                let viewController = ProfileSettingViewController.instantiateViewController(from: .intro)
                guard let profileSettingController = viewController else { return }
                profileSettingController.modalPresentationStyle = .fullScreen
                navigationController.present(profileSettingController, animated: false)
            }
        }
    }
    
}
