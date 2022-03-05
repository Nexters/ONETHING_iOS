//
//  MyHabitCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import SnapKit
import UIKit

class MyHabitCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.setupBackground()
        self.setupContentView()
        self.setupTitleDescriptionLabel()
        self.setupTitleLabel()
        self.setupNextImageView()
        self.setupVerticalBorderView()
    }
    
    private func layoutUI() {
        self.layoutTitleDescriptionLabel()
        self.layoutTitleLabel()
        self.layoutNextImageView()
        self.layoutVerticalBorderView()
    }
    
    private func setupBackground() {
        self.do {
            $0.clipsToBounds = false
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            $0.layer.shadowRadius = 10
            $0.layer.shadowPath = UIBezierPath(rect: $0.bounds).cgPath
            $0.layer.rasterizationScale = 1.0
        }
    }
    
    private func setupContentView() {
        self.contentView.do {
            $0.cornerRadius = 16
            $0.backgroundColor = .black_100
        }
    }
    
    private func setupTitleDescriptionLabel() {
        self.titleDescriptionLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            
            guard let userName = OnethingUserManager.sharedInstance.currentUser?.account?.name else { return }
            let index = 1
            $0.text = String(format: "%@ 님의 %@번째 성공 습관", arguments: [userName, "\(index)"])
        }
        
        self.contentView.addSubview(self.titleDescriptionLabel)
    }
    
    private func setupTitleLabel() {
        self.titleLabel.do {
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 26)
            $0.text = "책 읽기"
        }
        
        self.contentView.addSubview(self.titleLabel)
    }
    
    private func setupNextImageView() {
        self.nextImageView.do {
            $0.image = UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
            $0.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        self.contentView.addSubview(self.nextImageView)
    }
    
    private func setupVerticalBorderView() {
        self.firstVerticalBorderView.do {
            $0.backgroundColor = .black_80
        }
        
        self.secondVerticalBorderView.do {
            $0.backgroundColor = .black_80
        }
        
        self.contentView.addSubview(self.firstVerticalBorderView)
        self.contentView.addSubview(self.secondVerticalBorderView)
    }
    
    private func layoutTitleDescriptionLabel() {
        self.titleDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
        }
    }
    
    private func layoutTitleLabel() {
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalTo(self.nextImageView.snp.leading).offset(-10)
            make.top.equalTo(self.titleDescriptionLabel.snp.bottom).offset(10)
        }
    }
    
    private func layoutNextImageView() {
        self.nextImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.size.equalTo(24)
        }
    }
    
    private func layoutVerticalBorderView() {
        self.firstVerticalBorderView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
    }
    
    private let titleDescriptionLabel: UILabel = UILabel(frame: .zero)
    private let titleLabel: UILabel = UILabel(frame: .zero)
    private let nextImageView: UIImageView = UIImageView(frame: .zero)
    private let firstVerticalBorderView = UIView(frame: .zero)
    
    
}
