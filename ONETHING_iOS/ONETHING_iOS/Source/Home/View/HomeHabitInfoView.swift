//
//  HomeUpperView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HomeHabitInfoView: UIView {
    let progressView = ProgressView()
    let settingButton = SettingButton()
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let dayNumberLabel = UILabel()
    private let dayTextLabel = UILabel()
    private let descriptionLabelTopConstant: CGFloat
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    
    init(frame: CGRect, descriptionLabelTopConstant: CGFloat) {
        self.descriptionLabelTopConstant = descriptionLabelTopConstant
        super.init(frame: frame)
        
        self.setup()
        self.setupDescriptionLabel()
        self.setupSettingButton()
        self.setupTitleLabel()
        self.setupDayNumberLabel()
        self.setupDayTextLabel()
        self.setupProgressView()
        self.setupStartDateLabel()
        self.setupEndDateLabel()
    }
    
    required init?(coder: NSCoder) {
        self.descriptionLabelTopConstant = 0
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .black_100
    }
    
    private func setupDescriptionLabel() {
        self.descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        self.descriptionLabel.textColor = .white
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(self.descriptionLabelTopConstant)
            $0.leading.equalTo(self).offset(20)
        }
    }
    
    private func setupSettingButton() {
        self.addSubview(self.settingButton)
        self.settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-33)
            $0.top.equalTo(self.descriptionLabel.snp.top).offset(-30)
            $0.height.equalTo(21)
            $0.width.equalTo(self.settingButton.snp.height)
        }
    }
    
    private func setupTitleLabel() {
        self.titleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        self.titleLabel.textColor = .white
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(6)
            $0.leading.equalTo(self.descriptionLabel)
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupDayNumberLabel() {
        self.dayNumberLabel.font = UIFont(name: "Montserrat-Regular", size: 36)
        self.dayNumberLabel.textColor = .white
        
        self.addSubview(self.dayNumberLabel)
        self.dayNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-51)
            $0.bottom.equalTo(self.titleLabel).offset(2)
        }
    }
    
    private func setupDayTextLabel() {
        self.dayTextLabel.text = "일차"
        self.dayTextLabel.font = UIFont(name: "Pretendard-Regular", size: 10)
        self.dayTextLabel.textColor = .white
        
        self.addSubview(self.dayTextLabel)
        self.dayTextLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.lastBaseline.equalTo(self.dayNumberLabel)
        }
    }

    private func setupProgressView() {
        self.addSubview(self.progressView)
        
        self.progressView.snp.makeConstraints {
            $0.leading.equalTo(self.titleLabel)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(8)
        }
    }
    
    private func setupStartDateLabel() {
        self.startDateLabel.textColor = .white
        self.startDateLabel.font = UIFont(name: "Montserrat-Medium", size: 11)
        
        self.addSubview(self.startDateLabel)
        self.startDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.progressView.snp.bottom).offset(8)
            $0.leading.equalTo(self.progressView)
        }
    }
    
    private func setupEndDateLabel() {
        self.endDateLabel.textColor = .white
        self.endDateLabel.font = UIFont(name: "Montserrat-Medium", size: 11)
        
        self.addSubview(self.endDateLabel)
        self.endDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.startDateLabel)
            $0.trailing.equalTo(self.progressView)
        }
    }
    
    func update(with viewModel: HomeViewModel) {
        self.startDateLabel.text = viewModel.textOfStartDate
        self.endDateLabel.text = viewModel.textOfEndDate
        self.dayNumberLabel.text = viewModel.currentDayText
        self.titleLabel.text = viewModel.titleText
        self.descriptionLabel.text = viewModel.discriptionText
        self.backgroundColor = viewModel.habitInProgressModel?.onethingColor ?? .black_100
    }
}
