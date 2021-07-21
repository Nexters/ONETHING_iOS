//
//  CompletedButton.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class StampButton: UIButton, Circleable {

    override func layoutSubviews() {
        self.setupLayerCircle()
    }
    
}
