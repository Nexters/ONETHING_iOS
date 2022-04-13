//
//  DailyHistoryResponseModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

struct DailyHabitResponseModel: Codable, Equatable {
    var habitHistoryId: Int
    let habitId: Int
    let createDateTime: String
    let status: String
    var stampType: String?
    var content: String?
    var imageExtension: String?

    // for dummyData
    init(
        habitId: Int,
        status: String,
        createDateTime: String,
        habitHistoryId: Int = 0,
        stampType: String = Stamp.defaultType,
        content: String = "",
        imageExtension: String? = nil
        ) {
        self.habitId = habitId
        self.status = status
        self.habitHistoryId = habitHistoryId
        self.createDateTime = createDateTime
        self.stampType = stampType
        self.content = content
        self.imageExtension = imageExtension
    }
}

extension DailyHabitResponseModel {
    enum DailyStatus: String {
        case success = "SUCCESS"
        case delayPenalty = "DELAY_PENALTY"
        case delay = "DELAY"
    }
    
    var castingHabitStatus: DailyStatus? {
        DailyStatus(rawValue: self.status)
    }
    
    var castingStamp: Stamp? {
        Stamp(rawValue: stampType ?? Stamp.defaultType)
    }
    
    static var dateFormat: String {
        "yyyy-MM-dd'T'HH:mm:ss"
    }
}
