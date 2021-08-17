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
    let authType: String
    
    var castingAuthType: AuthType {
        guard let authType = AuthType(rawValue: self.authType) else { return .apple }
        
        return authType
    }
}

enum AuthType: String {
    case apple = "APPLE"
    case kakao = "KAKAO"
}
