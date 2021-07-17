//
//  HabitCalendarCell.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

class HabitCalendarCell: UICollectionViewCell, ReusableView {
    private let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray4
        configureNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .systemGray4
        configureNumberLabel()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    private func configureNumberLabel() {
        self.numberLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        self.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(numberText: String) {
        self.numberLabel.text = numberText
    }
}
