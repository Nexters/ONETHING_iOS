//
//  PercentView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class PercentView: UIView {
    private let completedPercentView = UIView()
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayer()
        configureCompletedPercentLabel()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureLayer()
        configureCompletedPercentLabel()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
    }
    
    private func configureLayer() {
        layer.cornerRadius = 7
    }
    
    private func configureCompletedPercentLabel() {
        self.completedPercentView.layer.cornerRadius = self.layer.cornerRadius
        self.completedPercentView.backgroundColor = .systemTeal
        
        self.addSubview(self.completedPercentView)
        self.completedPercentView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self)
            $0.width.equalTo(self.snp.width).multipliedBy(0.66)
        }
    }
    
    private func configureDescriptionLabel() {
        self.descriptionLabel.text = "예빈님의 2번째 습관"
        self.descriptionLabel.textColor = .darkGray
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(self).offset(23)
            $0.top.equalTo(self).offset(20)
        }
    }
    
    private func configureTitleLabel() {
        self.titleLabel.text = "물마시기"
        self.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .black)
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.descriptionLabel)
            $0.bottom.equalTo(self).offset(-17)
        }
    }
    
    private func configureDayLabel() {
        self.dayLabel.text = "42"
        self.dayLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        
        self.addSubview(self.dayLabel)
        self.dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(self).offset(-17)
        }
    }
}
