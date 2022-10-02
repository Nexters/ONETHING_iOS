//
//  GiveUpWarningPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/06.
//

import UIKit

final class GiveUpWarningPopupView: NNConfirmPopupView {
    private let dayView = UIView()
    private let dayNumberLabel = UILabel()
    private let dayTextLabel = UILabel()
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.heightOfContentView = 184.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        self.dayNumberLabel.do {
            $0.font = UIFont(name: FontType.montserrat(weight: .regular).fontName, size: 36.0)
            $0.textColor = .red_default
        }
        self.dayTextLabel.do {
            $0.text = "일차"
            $0.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 12.0)
            $0.textColor = .red_default
        }
        
        self.addSubview(self.dayView)
        self.dayView.addSubview(self.dayNumberLabel)
        self.dayView.addSubview(self.dayTextLabel)
        self.addSubview(self.subTitleLabel)
    }
    
    override func layoutUI() {
        super.layoutUI()
        
        self.dayView.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(30.0)
            $0.centerX.equalTo(self.contentView)
        }
        
        self.dayNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.dayTextLabel.snp.makeConstraints {
            $0.leading.equalTo(self.dayNumberLabel.snp.trailing).offset(5.0)
            $0.trailing.equalToSuperview()
            $0.lastBaseline.equalTo(self.dayNumberLabel)
        }
        
        self.subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.contentView).offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func update(with viewModel: GiveUpWarningPopupViewPresentable) {
        self.dayNumberLabel.text = viewModel.currentDayText
        self.subTitleLabel.attributedText = viewModel.subTitleTextOfGiveupWarningPopupView
    }
}
