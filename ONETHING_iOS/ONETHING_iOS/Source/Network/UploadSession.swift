//
//  UploadSession.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/20.
//

import Foundation
import Alamofire

class UploadSession: Session {
    static let sharedInstance: UploadSession = {
        let configuration = URLSessionConfiguration.default
        #warning("여기는 정책 결정 필요 몇초 뒤에 timeout 될지")
        configuration.timeoutIntervalForRequest = 180
        configuration.timeoutIntervalForResource = 180
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return UploadSession(configuration: configuration)
    }()
}
