//
//  NetworkInfomation.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/19.
//

import Foundation

enum NetworkInfomation {
    enum Request {
        enum HeaderKeys {
            static let contentType = "Content-type"
            static let authorization = "Authorization"
        }
        
        enum HeaderValues {
            static let json = "application/json"
            static let authorization = OnethingUserManager.sharedInstance.accessToken ?? ""
        }
        
        enum ParameterKeys {
            static let habitId = "habit_id"
        }
    }
}

extension NetworkInfomation {
    static var headers: [String: String] {
        return [NetworkInfomation.Request.HeaderKeys.contentType: NetworkInfomation.Request.HeaderValues.json,
                NetworkInfomation.Request.HeaderKeys.authorization: NetworkInfomation.Request.HeaderValues.authorization]
    }
}
