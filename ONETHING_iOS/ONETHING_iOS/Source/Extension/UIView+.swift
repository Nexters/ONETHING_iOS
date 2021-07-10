//
//  UIView+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UIView {
    
    /// 부분적으로 Corner Radius 줄 떄, [.bottomLeft, .bottomRight, .topLeft, .topRight, .allCorners] 선택 가능
    func makeCornerRadius(directions: UIRectCorner = .allCorners, radius: CGFloat) {
        UIRectCorner.
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: directions,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask        = CAShapeLayer()
        mask.path       = path.cgPath
        self.layer.mask = mask
    }
    
}
