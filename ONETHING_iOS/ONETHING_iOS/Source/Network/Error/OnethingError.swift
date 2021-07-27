//
//  OnethingError.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation
import Moya

extension Moya.Response {
    
    var onethingErrorModel: OnethingErrorModel? {
        let onethingErrorType = OnethingErrorModel.self
        guard let mappedData = try? self.mapString().data(using: .utf8) else { return nil }
        guard let decodedErrorModel = try? JSONDecoder().decode(onethingErrorType, from: mappedData) else { return nil }
        return decodedErrorModel
    }
    
}

enum OnethingError: Int, Error {
    case expiredAccessToken = 10    // Access Token 만료된 경우
    case expiredRefreshToken = 11   // Refresh Token 만료된 경우
}
