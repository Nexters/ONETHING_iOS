//
//  SocialAccessType.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import Foundation

enum SocialAccessType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    var appKey: String {
        switch self {
        case .kakao: return "1ede4162de99647c1cef1dc55b5383c3"
        case .apple: return ""
        }
    }
}
