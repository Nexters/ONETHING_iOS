//
//  MyHabitEmptyView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/04/04.
//

import UIKit
import Then
import SnapKit

class MyHabitEmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.stackView.do {
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 50
        }
        
        self.titleImageView.do {
            $0.image = UIImage(named: "history_empty_img")
        }
        
        self.titleLabel.do {
            $0.text =
            """
            아직 달성한 습관이 없어요.
            66일 동안 습관을 지속하고
            내 습관을 모아보세요!
            """
            $0.textColor = .black_60
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
            
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.titleImageView)
        self.stackView.addArrangedSubview(self.titleLabel)
    }
    
    private func layoutUI() {
        self.stackView.snp.makeConstraints { make in
            make.trailing.leading.centerY.equalToSuperview()
        }
    }
    
    private let stackView = UIStackView()
    private let titleImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    
}
