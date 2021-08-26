//
//  HomeHiddenView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/29.
//

import UIKit

protocol HomeEmptyViewDelegate: AnyObject {
    func homeEmptyViewDidTapSelectButton(_ homeEmptyView: HomeEmptyView)
}

final class HomeEmptyView: UIView {
    private let mainImageView = UIImageView()
    private let mainLabel = UILabel()
    private let habitSelectButton = UIButton()
    weak var delegate: HomeEmptyViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupMainImageView()
        self.setupMainLabel()
        self.setupHabitSelectButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupMainImageView() {
        self.mainImageView.do {
            $0.image = UIImage(named: "empty_home_img")
            $0.contentMode = .scaleAspectFit
        }
        
        self.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(308)
            $0.height.equalTo(176)
        }
    }
    
    private func setupMainLabel() {
        self.mainLabel.do {
            $0.numberOfLines = 2
            $0.textColor = .darkGray
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.text = "진행중인 습관이 없어요.\n새로운 습관을 더 만들어보세요!"
            $0.textAlignment = .center
        }
        
        self.addSubview(self.mainLabel)
        
        self.mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.mainImageView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(self.mainImageView)
            $0.height.equalTo(48)
        }
    }
    
    private func setupHabitSelectButton() {
        self.habitSelectButton.do {
            $0.setTitle("습관 시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor($0.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
            $0.titleLabel?.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 18)
            $0.backgroundColor = .black_100
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(habitSelectButtonDidTap), for: .touchUpInside)
        }
        
        self.addSubview(self.habitSelectButton)
        
        self.habitSelectButton.snp.makeConstraints {
            $0.top.equalTo(self.mainLabel.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(136)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func habitSelectButtonDidTap() {
        delegate?.homeEmptyViewDidTapSelectButton(self)
    }
}
