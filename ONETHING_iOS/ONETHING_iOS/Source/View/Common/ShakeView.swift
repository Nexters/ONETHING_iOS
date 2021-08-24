//
//  ShakeView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/24.
//

import UIKit

protocol ShakeView: UIView {
    func animateShaking()
}

extension ShakeView {
    func animateShaking() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}
