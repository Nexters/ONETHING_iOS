//
//  UserApi.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/19.
//

import Foundation

import Moya

enum UserApi {
    enum ServiceMode: String {
        case live
        case test
    }
    
    // Naming: Method + EndPoint
    case getUser
}

extension UserApi: TargetType {
    var baseURL: URL {
        return URL(string: "NONE, Not Yet.")!
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getUser:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return [NetworkInfomation.Request.HeaderKeys.contentType: NetworkInfomation.Request.HeaderValues.json,
                NetworkInfomation.Request.HeaderKeys.authorization: NetworkInfomation.Request.HeaderValues.authorizationKey]
    }
}
