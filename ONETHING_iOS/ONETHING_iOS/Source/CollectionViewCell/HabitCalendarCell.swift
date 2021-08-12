//
//  HabitCalendarCell.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HabitCalendarCell: UICollectionViewCell {
    static let placeholderImage = UIImage(named: "rabbit_none")
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
        self.isWritten = false
        self.mainImageView.image = Self.placeholderImage
        self.numberLabel.text = nil
        self.numberLabel.textColor = .black_60
    }

    private func setupImageView() {
        self.mainImageView.contentMode = .scaleAspectFit
        self.mainImageView.image = Self.placeholderImage
        
        self.contentView.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupNumberLabel() {
        self.numberLabel.font = UIFont(name: "Montserrat-Medium", size: 10)
        self.numberLabel.textColor = .black_60
        
        self.contentView.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.mainImageView).multipliedBy(13.0/14.0)
            $0.centerY.equalTo(self.mainImageView).multipliedBy(14.0/13.0)
        }
    }
    
    func setup(numberText: String) {
        self.numberLabel.text = numberText
    }
    
    func clearNumberText() {
        self.numberLabel.text = ""
    }
    
    func set(isWrtten written: Bool) {
        self.isWritten = written
    }
    
    func update(stampImage: UIImage?) {
        self.mainImageView.image = stampImage
    }
    
    func update(textColor: UIColor) {
        self.numberLabel.textColor = textColor
    }
    
    var stampImage: UIImage? {
        guard mainImageView.image != Self.placeholderImage else { return nil }
        return mainImageView.image
    }
}
