//
//  HabitCalendarCell.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HabitCalendarCell: UICollectionViewCell {
    private let numberLabel = UILabel()
    private let mainImageView = UIImageView()
    private(set) var isWritten: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupImageView()
        self.setupNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        self.mainImageView.image = UIImage(named: "rabbit_none")
        self.numberLabel.text = nil
    }

    private func setupImageView() {
        self.mainImageView.contentMode = .scaleAspectFit
        self.mainImageView.image = UIImage(named: "rabbit_none")
        
        self.contentView.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNumberLabel() {
        self.numberLabel.font = UIFont(name: "Montserrat-Medium", size: 10)
        
        self.contentView.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.mainImageView).multipliedBy(13.0/14.0)
            $0.centerY.equalTo(self.mainImageView).multipliedBy(14.0/13.0)
        }
    }
    
    func setup(numberText: String) {
        self.numberLabel.text = numberText
    }
    
    func set(isWrtten written: Bool) {
        self.isWritten = written
    }
    
    func update(stampImage: UIImage) {
        self.mainImageView.image = stampImage
    }
}
