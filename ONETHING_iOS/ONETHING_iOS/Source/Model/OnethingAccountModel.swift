//
//  OnethingAccountResponseModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/23.
//

import Foundation

struct OnethingAccountModel: Codable {
    var account: OnethingUserModel?
    let doneHabitSetting: Bool?
    
    mutating func updateUserModel(_ userModel: OnethingUserModel) {
        self.account = userModel
    }
}
