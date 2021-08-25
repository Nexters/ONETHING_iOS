//
//  ColorSelectView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

final class ColorSelectButton: UIButton {
    let checkView = UIView().then {
        $0.layer.borderColor = UIColor.black_20.cgColor
        $0.layer.borderWidth = 6
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupCheckView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupCheckView()
    }
    
    private func setupCheckView() {
        self.addSubview(self.checkView)
        
        self.checkView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self)
            $0.width.height.equalTo(44)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.checkView.layer.cornerRadius = self.checkView.bounds.width / 2.0
    }
}
