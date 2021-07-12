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
        
        configure()
        configureNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
        configureNumberLabel()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func configure(numberText: String) {
        numberLabel.text = numberText
    }
    
    private func configure() {
        
        self.backgroundColor = .systemGray4
    }
    
    private func configureNumberLabel() {
        numberLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
