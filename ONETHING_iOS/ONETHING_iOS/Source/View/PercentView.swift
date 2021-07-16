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
        
        configure()
        configureCompletedPercentLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
        configureCompletedPercentLabel()
    }
    
    private func configure() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .oneThingLightGray
    }
    
    private func configureCompletedPercentLabel() {
        self.completedPercentView.layer.cornerRadius = self.layer.cornerRadius
        self.completedPercentView.backgroundColor = .red_3
        
        self.addSubview(self.completedPercentView)
        self.completedPercentView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self)
            $0.width.equalTo(self.snp.width).multipliedBy(0.66)
        }
    }
}
