//
//  NSAttributedString+.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/03/2022.
//

import Foundation
import Lottie

extension NSAttributedString {
    func with(lineSpacing spacing: CGFloat, alignment: NSTextAlignment = .center) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineSpacing = spacing
            $0.alignment = alignment
        }
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }
}
