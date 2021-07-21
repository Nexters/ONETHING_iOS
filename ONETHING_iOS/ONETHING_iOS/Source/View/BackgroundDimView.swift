//
//  BackgroundDimView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class BackgroundDimView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .black
        self.alpha = 0.8
        self.isHidden = true
    }
}
