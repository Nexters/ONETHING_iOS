//
//  UILabel+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

extension UILabel {
    
    func sizeThatFits(_ inset: UIEdgeInsets) -> CGSize {
        let intrinsicSize = self.intrinsicContentSize
        
        let fitsWidth  = intrinsicSize.width + inset.left + inset.right
        let fitsHeight = intrinsicSize.height + inset.top + inset.bottom
        return CGSize(width: fitsWidth, height: fitsHeight)
    }
    
}
