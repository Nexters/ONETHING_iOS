//
//  SuccessBoxedView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/01/06.
//

import UIKit

import Then

final class SuccessBoxedView: UIView {
    private let upperLineView = UIView()
    private let lowerLineView = UIView()
    private let progressTitleLabel = UILabel()
    private let progressContentLabel = UILabel()
    private let percentTitleLabel = UILabel()
    private let percentContentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
        self.setupUpperLineView()
        self.setupProgressTitleLabel()
        self.setupProgressContentLabel()
        self.setupPercentTitleLabel()
        self.setupPercentContentLabel()
        self.setupLowerLineView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        self.addSubview(self.upperLineView)
        self.addSubview(self.progressTitleLabel)
        self.addSubview(self.progressContentLabel)
        self.addSubview(self.percentTitleLabel)
        self.addSubview(self.percentContentLabel)
        self.addSubview(self.lowerLineView)
    }
    
    private func setupUpperLineView() {
        self.upperLineView.backgroundColor = .black_20
        self.upperLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.5)
        }
    }
    
    private func setupProgressTitleLabel() {
        self.progressTitleLabel.do {
            $0.text = "진행 기간"
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.textColor = .black_60
        }
        
        self.progressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.upperLineView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
    }
    
    private func setupProgressContentLabel() {
        self.progressContentLabel.do {
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
        
        self.progressContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.progressTitleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setupPercentTitleLabel() {
        self.percentTitleLabel.do {
            $0.text = "성공률"
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.textColor = .black_60
        }
        
        self.percentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.progressTitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(self.progressTitleLabel)
        }
    }
    
    private func setupPercentContentLabel() {
        self.percentContentLabel.do {
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
        
        self.percentContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.percentTitleLabel)
            $0.trailing.equalTo(self.progressContentLabel)
        }
    }
    
    private func setupLowerLineView() {
        self.lowerLineView.backgroundColor = .black_20
        self.lowerLineView.snp.makeConstraints {
            $0.top.equalTo(self.percentTitleLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.5)
        }
    }
    
    func update(with viewModel: SuccessPopupViewModel?) {
        self.progressContentLabel.text = viewModel?.progressText
        self.percentContentLabel.text = viewModel?.percentText
    }
}
