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
    let nickName: String?
    let imageType: String?
    let enableAlarm: String?
    
    var castingAccessType: SocialAccessType {
        guard let authType = self.authType,
              let accessType = SocialAccessType(rawValue: authType)
        else { return .apple }
        
        return accessType
    }
    
    var castingImageType: ImageType {
        guard let strongImageType = self.imageType,
              let imageType = ImageType(rawValue: strongImageType)
        else { return .study }
        
        return imageType
    }
    
    var castingAlarm: AlarmToggle {
        guard let enableAlarm = self.enableAlarm,
              let alarmToggle = AlarmToggle(rawValue: enableAlarm)
        else { return .off }
        
        return alarmToggle
    }
    
    enum ImageType: String {
        case study = "STUDY"
        case strong = "STRONG"
        case heart = "HEART"
    }
    
    enum AlarmToggle: String {
        case on = "ON"
        case off = "OFF"
    }
}
