//
//  CALayer+.swift
//  ONETHING_iOS
//
//  Created by sdean on 2022/02/02.
//

import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = UIColor.black,
        alpha: Float = 0.1,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat = 0
    ) {
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
