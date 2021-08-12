//
//  Date+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/31.
//

import Foundation

extension Date {
    
    func convertString(
        format: String = "HH:mm",
        amSymbol: String? = nil,
        pmSymbol: String? = nil
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        formatter.amSymbol = amSymbol
        formatter.pmSymbol = pmSymbol
        return formatter.string(from: self)
    }
    
}

extension String {
    func convertToDate(format: String, locale: Locale = Locale(identifier: "ko_KR")) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
