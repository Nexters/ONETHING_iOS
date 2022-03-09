//
//  ShareItemView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import Then
import SnapKit
import UIKit

final class ShareItemView: UIView {
    
    var shareCategory: ShareSNSCategory = .instagram {
        didSet {
            self.updateUI(asCategory: self.shareCategory)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: DeviceInfo.screenWidth, height: 24)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.iconButton.do {
            $0.isUserInteractionEnabled = false
            $0.setImage(self.shareCategory.iconImage, for: .normal)
            $0.cornerRadius = 7
        }
        
        self.titleLabel.do {
            $0.text = self.shareCategory.title
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
        
        self.addSubview(self.iconButton)
        self.addSubview(self.titleLabel)
    }
    
    private func setupLayout() {
        
        self.iconButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconButton.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateUI(asCategory category: ShareSNSCategory) {
        self.iconButton.setImage(category.iconImage, for: .normal)
        self.titleLabel.text = category.title
        self.iconButton.backgroundColor = category.iconBackgroudColor
    }
    
    private let iconButton = UIButton(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    
}


