//
//  OnethingError.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation
import Moya

extension Moya.Response {
        
    var onethingError: OnethingError? {
        if self.statusCode == 401 { return .expiredAccessToken }
        
        guard let jsonData = try? self.mapString().data(using: .utf8)                             else { return nil }
        guard let errorModel = try? JSONDecoder().decode(OnethingErrorModel.self, from: jsonData) else { return nil }
        return errorModel.onethingError
    }
    
}

enum OnethingError: Int, Error {
    case expiredAccessToken            // Access Token 만료된 경우
    case expiredRefreshToken = 10000   // Refresh Token 만료된 경우
}
