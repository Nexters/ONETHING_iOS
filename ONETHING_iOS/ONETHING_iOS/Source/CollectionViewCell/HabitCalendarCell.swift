//
//  HabitCalendarCell.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

class HabitCalendarCell: UICollectionViewCell, ReusableView {
    private let numberLabel = UILabel()
    private let mainImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configureNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureImageView()
        configureNumberLabel()
    }

    private func configureImageView() {
        self.mainImageView.contentMode = .scaleAspectFit
        self.mainImageView.image = UIImage(named: "rabbit_none")
        
        self.contentView.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureNumberLabel() {
        self.numberLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        
        self.contentView.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.mainImageView).multipliedBy(13.0/14.0)
            $0.centerY.equalTo(self.mainImageView).multipliedBy(14.0/13.0)
        }
    }
    
    func configure(numberText: String) {
        self.numberLabel.text = numberText
    }
}
