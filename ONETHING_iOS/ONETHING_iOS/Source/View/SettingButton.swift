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
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        let settingImage = UIImage(named: "setting_btn")
        setImage(settingImage, for: .normal)
        imageView?.contentMode = .scaleAspectFill
    }
}
