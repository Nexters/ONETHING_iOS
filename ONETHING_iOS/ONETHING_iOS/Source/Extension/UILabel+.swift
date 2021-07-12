//
//  UILabel+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

extension UILabel {
    
    func getSize(_ inset: UIEdgeInsets) -> CGSize {
        let fitsSize = self.sizeThatFits(self.frame.size)
        
        let fitsWidth  = fitsSize.width + inset.left + inset.right
        let fitsHeight = fitsSize.height + inset.top + inset.bottom
        return CGSize(width: fitsWidth, height: fitsHeight)
    }
    
}
