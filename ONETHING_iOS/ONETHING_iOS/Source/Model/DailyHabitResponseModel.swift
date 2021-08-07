//
//  DailyHistoryResponseModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

struct DailyHabitResponseModel: Codable {
    let habitId: Int
    let status: String
    var habitHistoryId: Int
    let createDateTime: String
    var stampType: String?
    var content: String
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
        case fail = "FAIL"
    }
    
    var castingHabitStatus: DailyStatus? {
        DailyStatus(rawValue: self.status)
    }
    
    var castringStamp: Stamp? {
        Stamp(rawValue: stampType ?? Stamp.defaultType)
    }
    
    var dateString: String? {
        return self.createDateTime
            .convertToDate(format: Self.dateFormat)?
            .convertString(format: "yyyy-MM-dd")
    }
    
    var timeString: String? {
        return self.createDateTime
            .convertToDate(format: Self.dateFormat)?
            .convertString(format: "HH:mm PM")
    }
    
    static var dateFormat: String {
        "yyyy-MM-dd'T'HH:mm:ss"
    }
}
