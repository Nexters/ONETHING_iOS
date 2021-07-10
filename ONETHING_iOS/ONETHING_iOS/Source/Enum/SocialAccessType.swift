//
//  SocialAccessType.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import Foundation

enum SocialAccessType {
    case kakao
    case apple
    
    var appKey: String {
        switch self {
        case .kakao: return "1c31db7f755819769d9685b72f2506df"
        case .apple: return ""
        }
    }
}
