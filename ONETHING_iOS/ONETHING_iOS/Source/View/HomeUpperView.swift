//
//  HomeUpperView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HomeUpperView: UIView {
    private let titleLabel = UILabel()
    private let settingButton = SettingButton()
    private let percentView = PercentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTitleLabel()
        configureSettingButton()
        configurePercentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureTitleLabel()
        configureSettingButton()
        configurePercentView()
    }
    
    private func configureTitleLabel() {
        self.titleLabel.font = .boldSystemFont(ofSize: 25)
        self.titleLabel.text = "Habit"
        
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.top.equalTo(self)
            
        }
    }
    
    private func configureSettingButton() {
        self.addSubview(settingButton)
        self.settingButton.snp.makeConstraints {
            $0.trailing.equalTo(self)
            $0.centerY.equalTo(self.titleLabel)
            $0.height.equalTo(self.titleLabel)
            $0.width.equalTo(self.settingButton.snp.height)
        }
    }
    
    private func configurePercentView() {
        self.addSubview(percentView)
        self.percentView.backgroundColor = .systemGray5
        
        self.percentView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.top.equalTo(self.titleLabel.snp.top).offset(42)
            $0.bottom.equalTo(self)
        }
    }
}
