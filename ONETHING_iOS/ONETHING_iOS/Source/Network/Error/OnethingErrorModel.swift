//
//  OnethingErrorModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/27.
//

import Foundation

struct OnethingErrorModel: Codable {
    let status: Int?
    let errorCode: Int?
    let message: String?
}

extension OnethingErrorModel {
    
    var onethingError: OnethingError? {
        guard let errorCode = self.errorCode else { return nil }
        return OnethingError(rawValue: errorCode)
    }
    
}
