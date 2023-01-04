//
//  HistoryEmptyView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

final class HistoryEmptyView: UIView {
    let guideImageView = UIImageView()
    let guideLabel = UILabel()
    
    init(guideImage: UIImage, guideText: String) {
        super.init(frame: .zero)
        
        self.guideImageView.image = guideImage
        self.guideLabel.text = guideText
        self.setupUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        self.guideImageView.contentMode = .scaleAspectFit
        self.guideLabel.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        self.guideLabel.textColor = .black_60
        
        self.addSubview(self.guideImageView)
        self.addSubview(self.guideLabel)
    }
    
    private func setupLayout() {
        self.guideImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(107)
            $0.height.equalTo(89)
            $0.centerX.equalToSuperview()
        }
        
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(self.guideImageView.snp.bottom).offset(17)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
