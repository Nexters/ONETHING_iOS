//
//  CreateHabitReponseModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation

struct HabitResponseModel: Codable {
    let habitId: Int
    let habitStatus: String
    let title: String
    let sentence: String
    let startDate: String
    let pushTime: String
    let delayMaxCount: Int
    let penaltyCount: Int
    let delayCount: Int
    let successCount: Int
}

extension HabitResponseModel {
    
    enum HabitStatus: String {
        case run = "RUN"
        case pass = "PASS"
        case success = "SUCCESS"
        case fail = "FAIL"
    }

    var castingHabitStatus: HabitStatus? {
        guard let status = HabitStatus(rawValue: self.habitStatus) else { return nil }
        return status
    }
    
}
