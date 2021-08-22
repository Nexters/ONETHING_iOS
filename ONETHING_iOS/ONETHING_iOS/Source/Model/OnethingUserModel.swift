//
//  OnethingUserModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation

struct OnethingUserModel: Codable {
    let name: String?
    let email: String?
    let authType: String?
    let nickname: String?
    let imageType: String?
    let enableAlarm: String?
    
    var castingAccessType: SocialAccessType? {
        guard let authType = self.authType,
              let accessType = SocialAccessType(rawValue: authType)
        else { return nil }
        
        return accessType
    }
    
    var profileImageType: OnethingProfileType? {
        guard let strongImageType = self.imageType,
              let imageType = OnethingProfileType(rawValue: strongImageType)
        else { return nil }
        
        return imageType
    }
    
    var castingAlarm: AlarmToggle? {
        guard let enableAlarm = self.enableAlarm,
              let alarmToggle = AlarmToggle(rawValue: enableAlarm)
        else { return nil }
        
        return alarmToggle
    }
    
    enum AlarmToggle: String {
        case on = "ON"
        case off = "OFF"
    }
}
