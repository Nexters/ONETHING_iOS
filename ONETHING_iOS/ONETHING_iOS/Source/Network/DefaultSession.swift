//
//  DefaultSession.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/20.
//

import Foundation
import Alamofire

class DefaultSession: Session {
    static let sharedInstance: DefaultSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultSession(configuration: configuration)
    }()
}
