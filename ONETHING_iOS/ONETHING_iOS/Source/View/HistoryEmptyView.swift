//
//  HistoryEmptyView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/29.
//

import UIKit

final class HistoryEmptyView: UIView {
    private let mainImageView = UIImageView()
    private let mainLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupMainImageView()
        self.setupMainLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupMainImageView() {
        self.mainImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "history_empty_img")
        }
        
        self.addSubview(self.mainImageView)
        
        self.mainImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.mainImageView.snp.width).multipliedBy(0.4)
        }
    }
    
    private func setupMainLabel() {
        self.mainLabel.do {
            $0.text = "아직 달성한 습관이 없어요.\n66일 동안 습관을 지속하고\n내 습관을 모아보세요!"
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.textAlignment = .center
            $0.textColor = .darkGray
            $0.numberOfLines = 3
        }
        
        self.addSubview(self.mainLabel)
        
        self.mainLabel.snp.makeConstraints {
            $0.top.equalTo(self.mainImageView.snp.bottom).offset(62)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
