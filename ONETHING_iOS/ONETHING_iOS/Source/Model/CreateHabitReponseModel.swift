//
//  CreateHabitReponseModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation

struct CreateHabitResponseModel: Codable {
    let habitId: Int
    let habitStatus: String
    let title: String
    let sentence: String
    let startDate: String
    let pushTime: String
    let delayMaxCount: Int
    let delayCount: Int
}
