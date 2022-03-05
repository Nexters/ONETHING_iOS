//
//  AppleLoginRequestBody.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/24.
//

import Foundation

struct AppleLoginRequestBody {
    let authorizationCode: String
    let identityToken: String
    let userFullName: String?
}
