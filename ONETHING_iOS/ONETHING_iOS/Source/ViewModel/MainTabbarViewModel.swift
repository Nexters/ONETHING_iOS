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
        OnethingUserManager.sharedInstance.requestAccount { _ in }
    }
    
}
