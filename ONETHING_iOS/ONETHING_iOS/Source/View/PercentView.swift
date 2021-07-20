//
//  PercentView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class PercentView: UIView {
    private let completedPercentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupCompletedPercentLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
        self.completedPercentView.layer.cornerRadius = self.frame.height / 2
    }
    
    private func setup() {
        self.backgroundColor = .black_40
    }
    
    private func setupCompletedPercentLabel() {
        self.completedPercentView.layer.cornerRadius = self.layer.cornerRadius
        self.completedPercentView.backgroundColor = .red
        
        self.addSubview(self.completedPercentView)
        self.completedPercentView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self)
            $0.width.equalTo(self.snp.width).multipliedBy(0.66)
        }
    }
}
