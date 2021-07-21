//
//  CircleView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

protocol Circleable: UIView {
    func setupLayerCircle()
}

extension Circleable {
    func setupLayerCircle() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
