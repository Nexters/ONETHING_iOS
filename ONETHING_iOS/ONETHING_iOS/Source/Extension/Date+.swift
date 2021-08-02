//
//  Date+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/31.
//

import Foundation

extension Date {
    
    func convertString(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
