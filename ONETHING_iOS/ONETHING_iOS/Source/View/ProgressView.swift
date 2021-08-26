//
//  PercentView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class ProgressView: UIView {
    private let completedPercentView = UIView()
    private var ratio: Double?

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
        
        self.completedPercentView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(self)

            guard let ratio = self.ratio else { return }
            $0.width.equalTo(self.snp.width).multipliedBy(ratio)
        }
    }
    
    private func setup() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    private func setupCompletedPercentLabel() {
        self.completedPercentView.layer.cornerRadius = self.layer.cornerRadius
        self.completedPercentView.backgroundColor = .white
        
        self.addSubview(self.completedPercentView)

    }
    
    func update(ratio: Double) {
        self.ratio = ratio
        self.layoutSubviews()
    }
}
