//
//  OnethingErrorModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation


#warning("ErrorCode 필요함..")
struct OnethingErrorModel: Codable {
    let isSuccess: Bool?
    let errorCode: Int?
}

extension OnethingErrorModel {
    
    var onethingError: OnethingError? {
        guard let errorCode = self.errorCode else { return nil }
        return OnethingError(rawValue: errorCode)
    }
    
}
