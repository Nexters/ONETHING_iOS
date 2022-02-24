//
//  KakaoLoginReqeustBody.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/24.
//

import Foundation

struct KakaoLoginReqeustBody {
    let accessToken: String
    let refreshToken: String
    let refreshExpiresIn: TimeInterval
    let scope: String
}
