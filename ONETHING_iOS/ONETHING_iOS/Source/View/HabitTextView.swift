//
//  HabitTextView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

final class HabitTextView: UITextView {
    let placeholderLabel = UILabel()
    let textCountLabel = UILabel()
    private let firstBottomLine = UIView()
    let secondBottomLine = UIView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.setupUI()
        self.layoutUI()
        self.layoutManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.layoutUI()
    }
    
    private func setupUI() {
        self.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.spellCheckingType = .no
        }
        
        self.placeholderLabel.do {
            $0.text = "기록하고 싶은 습관 이야기를 적어보세요!"
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 16)
            $0.textColor = UIColor.init(hexString: "D7D7D7")
            $0.isHidden = false
        }
        
        self.firstBottomLine.backgroundColor = .black_10
        self.secondBottomLine.backgroundColor = .black_10
        
        self.textCountLabel.do {
            $0.textColor = .black_40
            $0.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
            $0.textAlignment = .center
            $0.text = countText
        }
        
        self.addSubview(self.placeholderLabel)
        self.addSubview(self.firstBottomLine)
        self.addSubview(self.secondBottomLine)
        self.addSubview(self.textCountLabel)
    }
    
    private func layoutUI() {
        let beginPosition = self.beginningOfDocument
        let beginOrigin = self.caretRect(for: beginPosition).origin
        self.placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(beginOrigin.x)
            $0.top.equalToSuperview().offset(beginOrigin.y)
        }
        
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
        
        self.textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.firstBottomLine)
            $0.top.equalTo(self.firstBottomLine.snp.bottom)
            $0.bottom.equalTo(self.secondBottomLine.snp.top)
        }
    }

    private var countText: String {
        return "\(self.text.count) / \(self.textLimit)"
    }
}

extension HabitTextView: NSLayoutManagerDelegate {
    func layoutManager(
        _ layoutManager: NSLayoutManager,
        lineSpacingAfterGlyphAt glyphIndex: Int,
        withProposedLineFragmentRect rect: CGRect
    ) -> CGFloat {
        return 24
    }
}

extension HabitTextView: UITextViewDelegate {
    var textLimit: Int {
        return 40
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textViewTextCount = textView.text?.count ?? 0
        let totalLength = textViewTextCount + text.count - range.length
        return totalLength <= self.textLimit
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.text != "\n" else {
            textView.text.removeLast()
            textView.resignFirstResponder()
            return
        }
        
        self.showOrHidePlaceholderLabel(with: textView)
        self.updateCountLabel(with: textView)
    }
    
    private func showOrHidePlaceholderLabel(with textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false
        } else {
            self.placeholderLabel.isHidden = true
        }
    }
    
    private func updateCountLabel(with textView: UITextView) {
        guard textView is HabitTextView else { return }
        
        self.textCountLabel.text = self.countText
    }
}
