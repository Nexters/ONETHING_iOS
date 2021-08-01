//
//  UserApi.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/19.
//

import Foundation

import Moya

enum UserAPI {
    case appleLogin(authorizationCode: String, identityToken: String, userName: String? = nil)
    case account
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServerHost.main)!
    }
    
    var path: String {
        switch self {
        case .appleLogin: return "/auth/apple/login"
        case .account: return "/api/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin: return .post
        case .account: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .appleLogin(let authorizationCode, let identityToken, let userName):
            var parameters: [String: Any] = ["authorizationCode": authorizationCode, "identityToken": identityToken]
            if let userName = userName { parameters["userName"] = userName }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .account:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkInfomation.headers
    }
}
