//
//  MyHabitShareFirstTypeView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/06.
//

import SnapKit
import Then

import UIKit

class MyHabitShareFirstTypeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.do {
            $0.backgroundColor = .black_100
        }
        
        self.backgroundImageView.do {
            $0.image = UIImage(named: "share_img_1")
        }
        
        self.titleLabel.do {
            $0.text = "Congratulations!"
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .montserrat(weight: .bold), size: 30)
        }
        
        self.subTitleLabel.do {
            $0.text = "66일 습관 성공!"
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 20)
        }
        
        self.habitTitleContainerView.do {
            $0.backgroundColor = .white
            $0.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        self.habitTitleLabel.do {
            // TODO: - 습관 이름에 따라 반영 필요
            $0.text = "임시 텍스트야!!"
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 14)
        }
        
        self.progressDurationLabel.do {
            $0.text = "21.07.21 - 21-08-30"
            $0.textColor = .black_60
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 12)
        }
        
        self.nicknameLabel.do {
            // TODO: - 닉네임에 따라 반영 필요
            $0.text = "@닉네임"
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 16)
        }
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.habitTitleContainerView)
        self.habitTitleContainerView.addSubview(self.habitTitleLabel)
        self.addSubview(self.progressDurationLabel)
        self.addSubview(self.nicknameLabel)
    }
    
    private func setupLayout() {
        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.habitTitleContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        self.habitTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        self.progressDurationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.habitTitleContainerView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
        }
        
        self.nicknameLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
        }
    }
    
    private let backgroundImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subTitleLabel = UILabel(frame: .zero)
    private let habitTitleContainerView = UIView(frame: .zero)
    private let habitTitleLabel = UILabel(frame: .zero)
    private let progressDurationLabel = UILabel(frame: .zero)
    private let nicknameLabel = UILabel(frame: .zero)

}
