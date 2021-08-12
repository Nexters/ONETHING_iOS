//
//  CompleteButton.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import UIKit

final class CompleteButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.setTitle("저장하기", for: .normal)
        self.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 20)
        self.backgroundColor = .black_100
    }
}
