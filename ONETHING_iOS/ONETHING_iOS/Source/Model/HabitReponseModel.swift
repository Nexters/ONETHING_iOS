//
//  CreateHabitReponseModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import UIKit

struct HabitResponseModel: Codable {
    let habitId: Int
    let habitStatus: String
    let title: String
    let sentence: String
    let startDate: String
    var pushTime: String?
    let delayMaxCount: Int
    let delayCount: Int
    var penaltyCount: Int
    let successCount: Int
    var color: String
}

extension HabitResponseModel: MyHabitCellPresentable {

    var onethingHabitStatus: HabitStatus? {
        guard let status = HabitStatus(rawValue: self.habitStatus) else { return nil }
        return status
    }
    
    var onethingColor: UIColor {
        guard let onethingColor = OnethingColor(rawValue: color) else { return .green_1 }
        return onethingColor.color
    }
    
}
