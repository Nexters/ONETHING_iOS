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

#warning("여기 코드도 임시 - 서버랑 얘기되어야함... 아직...")
enum OnethingError: Int, Error {
    case expiredAccessToken = 10    // Access Token 만료된 경우
    case expiredRefreshToken = 11   // Refresh Token 만료된 경우
}
