//
//  DailyHistoryResponseModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import UIKit

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
    
    var hasImageData: Bool {
        return self.imageExtension != nil
    }
    
    var hasDocument: Bool {
        return self.content != nil
    }
    
    var statusText: String? {
        guard let status = self.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return "성공"
            case .delayPenalty:
                fallthrough
            case .delay:
                return "미룸"
        }
    }
    
    var statusColor: UIColor? {
        guard let status = self.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return .red_default
            case .delayPenalty:
                fallthrough
            case .delay:
                return .mint_2
        }
    }
    
    var dateText: String? {
        self.createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "yyyy-MM-dd")
    }
    
    var timeText: String? {
        self.createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "h:mm a", amSymbol: "AM", pmSymbol: "PM")
    }
    
    var isDelayStamp: Bool {
        let status = self.castingHabitStatus
        return status == .delay || status == .delayPenalty
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
    
    var castingStamp: Stamp {
        let stamp = Stamp(rawValue: stampType ?? Stamp.defaultType)
        return stamp ?? .beige
    }
    
    var isDelayPenaltyHabit: Bool {
        return self.castingHabitStatus == .delayPenalty
    }
    
    static var dateFormat: String {
        "yyyy-MM-dd'T'HH:mm:ss"
    }
}
