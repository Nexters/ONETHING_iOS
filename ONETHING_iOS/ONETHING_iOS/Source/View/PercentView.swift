//
//  PercentView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class PercentView: UIView {
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayer()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayer()
        configureDescriptionLabel()
        configureTitleLabel()
        configureDayLabel()
    }
    
    private func configureLayer() {
        layer.cornerRadius = 7
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = "예빈님의 2번째 습관"
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(self).offset(23)
            $0.top.equalTo(self).offset(20)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "물마시기"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .black)
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionLabel)
            $0.bottom.equalTo(self).offset(-17)
        }
    }
    
    private func configureDayLabel() {
        dayLabel.text = "42"
        dayLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(self).offset(-17)
        }
    }
}
