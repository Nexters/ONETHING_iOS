//
//  NNConfirmPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

class NNConfirmPopupView: UIView {
    let contentView = UIView()
    private let underLine = UIView()
    private let verticalLine = UIView()
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    var confirmAction: ((NNConfirmPopupView) -> Void)?
    var cancelAction: ((NNConfirmPopupView) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = 16.0
        self.backgroundColor = .white
        self.setupContentView()
        self.setupUnderLine()
        self.setupConfirmButton()
        self.setupVerticalLine()
        self.setupCancelButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupContentView() {
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(self.heightOfContentView)
        }
    }
    
    var heightOfContentView: CGFloat {
        return 0.0
    }
    
    var buttons: [UIButton] {
        return [self.confirmButton, self.cancelButton]
    }
    
    private func setupUnderLine() {
        self.underLine.backgroundColor = .black_10
        
        self.addSubview(self.underLine)
        self.underLine.snp.makeConstraints{
            $0.top.equalTo(self.contentView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
    
    private func setupConfirmButton() {
        self.confirmButton.do {
            $0.setTitle("네", for: .normal)
            $0.setTitleColor(.black_100, for: .normal)
            $0.titleLabel?.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16.0)
        }
        
        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.top.equalTo(self.underLine.snp.bottom)
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.width.equalTo(106.0)
        }
        
        self.confirmButton.addTarget(self, action: #selector(self.invokeConfirmAction), for: .touchUpInside)
    }
    
    @objc private func invokeConfirmAction() {
        self.confirmAction?(self)
    }
    
    private func setupVerticalLine() {
        self.verticalLine.backgroundColor = .black_10
        self.addSubview(self.verticalLine)
        self.verticalLine.snp.makeConstraints {
            $0.top.equalTo(self.confirmButton)
            $0.leading.equalTo(self.confirmButton.snp.trailing)
            $0.width.equalTo(1.0)
            $0.height.equalTo(self.confirmButton)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupCancelButton() {
        self.cancelButton.do {
            $0.setTitle("아니오", for: .normal)
            $0.setTitleColor(.black_100, for: .normal)
            $0.titleLabel?.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16.0)
            
        }
        
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.top.equalTo(self.underLine.snp.bottom)
            $0.leading.equalTo(self.verticalLine.snp.trailing)
            $0.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(self.confirmButton)
        }
        
        self.cancelButton.addTarget(self, action: #selector(self.invokeCancelAction), for: .touchUpInside)
    }
    
    @objc private func invokeCancelAction() {
        self.cancelAction?(self)
    }
}
