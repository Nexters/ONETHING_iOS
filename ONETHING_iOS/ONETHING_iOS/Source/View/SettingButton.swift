//
//  SettingButton.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class SettingButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        let settingImage = UIImage(systemName: "ellipsis")
        self.setImage(settingImage, for: .normal)
        self.tintColor = .black_40
        imageView?.contentMode = .scaleAspectFit
    }
}
