//
//  UIFont+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/21.
//

import UIKit

extension UIFont {
    
    static func createFont(type: FontType, size: CGFloat) -> UIFont? {
        return UIFont(name: type.fontName, size: size)
    }
    
}
