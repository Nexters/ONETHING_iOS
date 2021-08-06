//
//  DailyHistoryResponseModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

struct DailyHabitResponseModel: Codable {
    let habitHistoryId: Int
    let habitId: Int
    let createDateTime: String
    let status: String
    let stampType: String
    let content: String
    var imageExtension: String?
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
        Stamp(rawValue: stampType)
    }
    
    var dateFormat: String {
        "yyyy-MM-ddTHH:mm:ss"
    }
}
