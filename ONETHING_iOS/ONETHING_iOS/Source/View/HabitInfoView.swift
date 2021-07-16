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
    private let dayNumberLabel = UILabel()
    private let dayTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        configure()
        configureSettingButton()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayNumberLabel()
        configureDayTextLabel()
        configurePercentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
        configureSettingButton()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayNumberLabel()
        configureDayTextLabel()
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
    
    private func configureDayNumberLabel() {
        self.dayNumberLabel.text = "19"
        self.dayNumberLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        self.dayNumberLabel.textColor = .white
        
        self.addSubview(self.dayNumberLabel)
        self.dayNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-51)
            $0.bottom.equalTo(self.titleLabel).offset(2)
        }
    }
    
    private func configureDayTextLabel() {
        self.dayTextLabel.text = "일 째"
        self.dayTextLabel.font = UIFont.systemFont(ofSize: 9)
        self.dayTextLabel.textColor = .white
        
        self.addSubview(self.dayTextLabel)
        self.dayTextLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.lastBaseline.equalTo(self.dayNumberLabel)
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
