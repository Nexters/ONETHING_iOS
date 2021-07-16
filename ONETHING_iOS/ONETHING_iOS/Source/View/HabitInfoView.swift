//
//  HomeUpperView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HabitInfoView: UIView {
    private let settingButton = SettingButton()
    private let percentView = PercentView()
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        configure()
        configureSettingButton()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
        configurePercentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
        configureSettingButton()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
        configurePercentView()
    }
    
    private func configure() {
        self.backgroundColor = .black_100
    }
    
    private func configureSettingButton() {
        self.addSubview(self.settingButton)
        self.settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-33)
            $0.top.equalToSuperview().offset(40)
            $0.height.equalTo(21)
            $0.width.equalTo(self.settingButton.snp.height)
        }
    }
    
    private func configureDescriptionLabel() {
        self.descriptionLabel.text = "예빈님의 2번째 습관"
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.descriptionLabel.textColor = .white
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.settingButton).offset(25)
            $0.leading.equalTo(self).offset(29)
        }
    }
    
    private func configureTitleLabel() {
        self.titleLabel.text = "물 한 잔 마시기"
        self.titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .black)
        self.titleLabel.textColor = .white
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(6)
            $0.leading.equalTo(self.descriptionLabel)
        }
    }
    
    private func configureDayLabel() {
        self.dayLabel.text = "19"
        self.dayLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        self.dayLabel.textColor = .white
        
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.titleLabel)
            $0.trailing.equalToSuperview().offset(-51)
        }
    }
    
    private func configurePercentView() {
        self.addSubview(self.percentView)
        
        self.percentView.snp.makeConstraints {
            $0.leading.equalTo(self.titleLabel)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(8)
        }
    }
}
