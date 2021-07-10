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
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.text = "Habit"
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalTo(self)
            
        }
    }
    
    private func configureSettingButton() {
        self.addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.trailing.equalTo(self)
            $0.centerY.equalTo(titleLabel)
            $0.height.equalTo(titleLabel)
            $0.width.equalTo(settingButton.snp.height)
        }
    }
    
    private func configurePercentView() {
        self.addSubview(percentView)
        percentView.backgroundColor = .systemGray5
        
        percentView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.top.equalTo(titleLabel.snp.top).offset(42)
            $0.bottom.equalTo(self)
        }
    }
}
