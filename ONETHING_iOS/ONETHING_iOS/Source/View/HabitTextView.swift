//
//  HabitTextView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

final class HabitTextView: UITextView {
    private let placeholderLabel = UILabel()
    private let firstBottomLine = UIView()
    private let secondBottomLine = UIView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupPlaceholderLabel()
        self.setupBottomLines()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        self.layoutPlaceholderLabel()
        self.layoutBottomLines()
    }
    
    private func setupPlaceholderLabel() {
        self.placeholderLabel.do {
            $0.text = "기록하고 싶은 습관 이야기를 적어보세요!"
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 16)
            $0.textColor = UIColor.init(hexString: "D7D7D7")
        }
        self.addSubview(self.placeholderLabel)
    }
    
    private func setupBottomLines() {
        self.firstBottomLine.backgroundColor = .black_10
        self.secondBottomLine.backgroundColor = .black_10
        self.addSubview(self.firstBottomLine)
        self.addSubview(self.secondBottomLine)
    }
    
    private func layoutPlaceholderLabel() {
        let beginPosition = self.beginningOfDocument
        let beginOrigin = self.caretRect(for: beginPosition).origin
        self.placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(beginOrigin.x)
            $0.top.equalToSuperview().offset(beginOrigin.y)
        }
    }
    
    private func layoutBottomLines() {
        self.firstBottomLine.snp.makeConstraints {
            $0.top.equalTo(self.placeholderLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.secondBottomLine.snp.makeConstraints {
            $0.top.equalTo(self.firstBottomLine.snp.bottom).offset(44)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
