//
//  NetworkInfomation.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/19.
//

import Foundation

struct NetworkInfomation {
    
    struct HeaderKey {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    struct HeaderValue {
        static let json = "application/json"
        static var authorization: String { return "Bearer " + (OnethingUserManager.sharedInstance.accessToken ?? "") }
    }
    
    struct ParameterKey {
        static let habitId = "habit_id"
    }
    
}

extension NetworkInfomation {
    
    static var headers: [String: String] {
        return [NetworkInfomation.HeaderKey.contentType: NetworkInfomation.HeaderValue.json,
                NetworkInfomation.HeaderKey.authorization: NetworkInfomation.HeaderValue.authorization]
    }
    
}
