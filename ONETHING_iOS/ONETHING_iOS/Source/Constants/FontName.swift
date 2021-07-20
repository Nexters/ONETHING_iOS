//
//  FontName.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import Foundation

struct FontName {
    
    static var pretendard_semibold: String { return self.prentendard + "-" + Weight.semiBold.rawValue }
    static var pretendard_bold: String { return self.prentendard + "-" + Weight.bold.rawValue }
    static var pretendard_extrabold: String { return self.prentendard + "-" + Weight.extraBold.rawValue }
    static var pretendard_light: String { return self.prentendard + "-" + Weight.light.rawValue }
    static var pretendard_medium: String { return self.prentendard + "-" + Weight.medium.rawValue }
    static var pretendard_regular: String { return self.prentendard + "-" + Weight.regular.rawValue }
    
    static var montserrat_semibold: String { return self.montserrat + "-" + Weight.semiBold.rawValue }
    static var montserrat_bold: String { return self.montserrat + "-" + Weight.bold.rawValue }
    static var montserrat_extrabold: String { return self.montserrat + "-" + Weight.extraBold.rawValue }
    static var montserrat_light: String { return self.montserrat + "-" + Weight.light.rawValue }
    static var montserrat_medium: String { return self.montserrat + "-" + Weight.medium.rawValue }
    static var montserrat_regular: String { return self.montserrat + "-" + Weight.regular.rawValue }
    
    private static let prentendard = "Pretendard"
    private static let montserrat = "Montserrat"

}

extension FontName {
    
    private enum Weight: String {
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
    }
    
}
