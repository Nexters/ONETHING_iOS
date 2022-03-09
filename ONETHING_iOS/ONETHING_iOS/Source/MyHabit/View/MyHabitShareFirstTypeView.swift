//
//  MyHabitShareFirstTypeView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/06.
//

import SnapKit
import Then

import UIKit

/// Figma 1, 2번째 공유하기에 해당하는 ContentView
/// First, Second는 BackgroundImage와 Title Text만 다름
/// - `First` : Figma 첫번째 타입의 뷰
/// - `Second` : Figma 두번째 타입의 뷰
class MyHabitShareFirstTypeView: UIView {
    
    var shareUIType: HabitShareUIType = .first {
        didSet {
            self.updateUI(asType: self.shareUIType)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateShareHabit(_ habit: MyHabitCellPresentable) {
        self.habitTitleLabel.text = habit.title
        self.progressDurationLabel.text = habit.progressDuration
        self.nicknameLabel.text = "@\(OnethingUserManager.sharedInstance.currentUser?.account?.nickname ?? "")"
    }
    
    private func setupUI(){
        self.do {
            $0.backgroundColor = .black_100
        }
        
        self.backgroundImageView.do {
            $0.image = self.shareUIType.backgroundImage
        }
        
        self.titleLabel.do {
            $0.text = self.shareUIType.titleText
            $0.textColor = .white
            $0.font = UIFont.createFont(type: .montserrat(weight: .bold), size: 30)
        }
        
        self.subTitleLabel.do {
            $0.text = self.shareUIType.subTitleText
            $0.textColor = .white
            $0.font = self.shareUIType == .first ?
            UIFont.createFont(type: .pretendard(weight: .semiBold), size: 20) :
            UIFont.createFont(type: .montserrat(weight: .bold), size: 30)

        }
        
        self.habitTitleContainerView.do {
            $0.backgroundColor = .white
            $0.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        self.habitTitleLabel.do {
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 14)
        }
        
        self.progressDurationLabel.do {
            $0.textColor = .black_60
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 12)
        }
        
        self.nicknameLabel.do {
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
    
    private func updateUI(asType type: HabitShareUIType) {
        self.titleLabel.text = type.titleText
        self.subTitleLabel.text = type.subTitleText
        self.backgroundImageView.image = type.backgroundImage
        
        self.subTitleLabel.font = type == .first ?
        UIFont.createFont(type: .pretendard(weight: .semiBold), size: 20) :
        UIFont.createFont(type: .montserrat(weight: .bold), size: 30)
    }
    
    private let backgroundImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subTitleLabel = UILabel(frame: .zero)
    private let habitTitleContainerView = UIView(frame: .zero)
    private let habitTitleLabel = UILabel(frame: .zero)
    private let progressDurationLabel = UILabel(frame: .zero)
    private let nicknameLabel = UILabel(frame: .zero)

}
