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
            static let json =  "application/json"
            static let authorizationKey =  "bearer EbTnTgX_t1zEp67w27Yrgf2vsusWsaU5TjoivQo9dVsAAAF6kMJCqQ"
        }
        
        enum ParameterKeys {
            static let habitId = "habit_id"
        }
    }
}
