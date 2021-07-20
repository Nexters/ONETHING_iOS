//
//  FontName.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import UIKit

enum FontType {
    
    case pretendard(weight: FontWeight)
    case montserrat(weight: FontWeight)
    
    var fontName: String {
        switch self {
        case .pretendard(let weight): return FontName.prentendard + "-" + weight.rawValue
        case .montserrat(let weight): return FontName.montserrat + "-" + weight.rawValue
        }
    }
    
}

extension FontType {
    
    enum FontWeight: String {
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
    }

}

struct FontName {
    static let prentendard = "Pretendard"
    static let montserrat = "Montserrat"
}
