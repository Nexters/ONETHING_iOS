//
//  CircleView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class CircleView: UIView, Circleable {
    override func layoutSubviews() {
        setupLayerCircle()
    }
}
