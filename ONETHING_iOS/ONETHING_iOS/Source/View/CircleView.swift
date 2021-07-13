//
//  CircleView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

protocol CircleView: UIView {
    func configureLayerCircle()
}

extension CircleView {
    func configureLayerCircle() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
