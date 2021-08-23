//
//  UserApi.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/19.
//

import Foundation

import Moya

enum UserAPI {
    case logout(accessToken: String, refreshToken: String)
    case appleLogin(authorizationCode: String, identityToken: String, userName: String? = nil)
    case refresh(accessToken: String, refreshToken: String)
    case account
    case withdrawl(accessToken: String, refreshToken: String)
    case setProfile(nickname: String, imageType: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServerHost.main)!
    }
    
    var path: String {
        switch self {
        case .logout:       return "/auth/logout"
        case .appleLogin:   return "/auth/apple/login"
        case .refresh:      return "/auth/token/refresh"
        case .account:      return "/api/account"
        case .withdrawl:    return "/auth/sign-out"
        case .setProfile:   return "/api/account/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout:       fallthrough
        case .appleLogin:   fallthrough
        case .withdrawl:    fallthrough
        case .refresh:      return .post
        case .account:      return .get
        case .setProfile:   return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .logout(let accessToken, let refreshToken):
            let parameters: [String: Any] = ["accessToken": accessToken, "refreshToken": refreshToken]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .appleLogin(let authorizationCode, let identityToken, let userName):
            var parameters: [String: Any] = ["authorizationCode": authorizationCode, "identityToken": identityToken]
            if let userName = userName { parameters["userName"] = userName }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .refresh(let accessToken, let refreshToken):
            return .requestParameters(parameters: ["accessToken": accessToken, "refreshToken": refreshToken],
                                      encoding: JSONEncoding.default)
        case .account:
            return .requestPlain
        case .withdrawl(let accessToken, let refreshToken):
            return .requestParameters(parameters: ["accessToken": accessToken, "refreshToken": refreshToken],
                                      encoding: JSONEncoding.default)
        case .setProfile(let nickname, let imageType):
            return .requestParameters(parameters: ["nickname": nickname, "imageType": imageType],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return NetworkInfomation.headers
    }
}
