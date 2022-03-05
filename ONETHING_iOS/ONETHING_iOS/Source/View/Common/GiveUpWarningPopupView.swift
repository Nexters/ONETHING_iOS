//
//  GiveUpWarningPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/06.
//

import UIKit

final class GiveUpWarningPopupView: NNConfirmPopupView {
    private let dayNumberLabel = UILabel()
    private let dayTextLabel = UILabel()
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func setupContentView() {
        super.setupContentView()
        
        self.setupDayNumberLabel()
        self.setupDayTextLabel()
        self.setupSubTitleLabel()
    }
    
    override var heightOfContentView: CGFloat {
        return 184.0
    }
    
    func update(with viewModel: HomeViewModel) {
        self.dayNumberLabel.text = viewModel.currentDayText
        self.subTitleLabel.attributedText = viewModel.subTitleTextOfGiveupWarningPopupView
    }
    
    private func setupDayNumberLabel() {
        self.dayNumberLabel.do {
            $0.font = UIFont(name: FontType.montserrat(weight: .regular).fontName, size: 36.0)
            $0.textColor = .red_default
        }
        
        self.addSubview(self.dayNumberLabel)
        self.dayNumberLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(30.0)
            $0.leading.equalTo(self.contentView).offset(80.0)
        }
    }
        
    private func setupDayTextLabel() {
        self.dayTextLabel.do {
            $0.text = "일차"
            $0.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 12.0)
            $0.textColor = .red_default
        }
        
        self.addSubview(self.dayTextLabel)
        self.dayTextLabel.snp.makeConstraints {
            $0.leading.equalTo(self.dayNumberLabel.snp.trailing).offset(5.0)
            $0.lastBaseline.equalTo(self.dayNumberLabel)
        }
    }
    
    private func setupSubTitleLabel() {
        self.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.contentView).offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
}
