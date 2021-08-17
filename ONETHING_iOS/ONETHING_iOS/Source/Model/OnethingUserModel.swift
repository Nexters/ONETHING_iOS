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
    
    var castingAccessType: SocialAccessType {
        guard let authType = self.authType, let accessType = SocialAccessType(rawValue: authType)
        else { return .apple }
        
        return accessType
    }
}
