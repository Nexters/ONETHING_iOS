//
//  LoginResponseModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

struct LoginResponseModel: Codable {
    let token: TokenResponseModel?
}

struct TokenResponseModel: Codable {
    let grantType: String?
    let accessToken: String?
    let refreshToken: String?
    let accessTokenExpiresIn: Int?
}
