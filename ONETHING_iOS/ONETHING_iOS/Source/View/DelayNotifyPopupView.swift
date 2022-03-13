//
//  DelayNotifyPopupView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 11/03/2022.
//

import UIKit

final class DelayNotifyPopupView: NotifyPopupView {
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let secondTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func setupContentView() {
        super.setupContentView()
        
        self.setupTitleLabel()
        self.setupSecondTitleLabel()
        self.setupSubTitleLabel()
    }
    
    override var heightOfContentView: CGFloat {
        return 234.0
    }
    
    override func show(in superview: UIView) {
        super.show(in: superview)
        
        self.snp.removeConstraints()
        self.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50.0)
        })
    }
    
    private func setupTitleLabel() {
        self.titleLabel.attributedText = self.titleText
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20.0)
            $0.centerX.equalToSuperview()
        })
    }
    
    private func setupSecondTitleLabel() {
        self.secondTitleLabel.attributedText = self.secondTitleText
        
        self.contentView.addSubview(self.secondTitleLabel)
        self.secondTitleLabel.snp.makeConstraints({
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(38.0)
            $0.centerX.equalToSuperview()
        })
    }
    
    private func setupSubTitleLabel() {
        self.subTitleLabel.attributedText = self.subTitleText
        
        self.contentView.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        })
    }
    
    private var titleText: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .semiBold),
            size: 16)
        else { return nil }
        
        let titleText = "66일 동안 총 6번의\n습관 미루기 기회가 있어요!"
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        return attributeText.with(lineSpacing: 4.0)
    }
    
    private var secondTitleText: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .semiBold),
            size: 16)
        else { return nil }
        
        let text = "6번 모두 사용하면\n습관 실패!"
        let attributeText = NSMutableAttributedString(
            string: text,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        attributeText.addAttribute(
            .foregroundColor,
            value: UIColor.red_default,
            range: (text as NSString).range(of: "습관 실패!")
        )
        return attributeText.with(lineSpacing: 4.0)
    }
    
    private var subTitleText: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .regular),
            size: 12)
        else { return nil }
        
        let text = "습관 실패시\n더 이상 습관을 지속할 수 없으며\n처음으로 리셋돼요!"
        let attributeText = NSMutableAttributedString(
            string: text,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        
        return attributeText.with(lineSpacing: 2.0)
    }
}
