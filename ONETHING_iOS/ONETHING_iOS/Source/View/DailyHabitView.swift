//
//  DailyHabitView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

final class DailyHabitView: UIView {
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let photoView = UIImageView()
    private let enrollPhotoButton = UIButton()
    private let habitTextView = HabitTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupPhotoView()
        self.setupEnrollPhotoButton()
        self.setupHabitTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTimeLabel() {
        self.timeLabel.text = "5:05 PM"
        self.timeLabel.textColor = .black_40
        self.timeLabel.font = UIFont(name: FontName.montserrat_medium, size: 10)
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.top)
        }
    }
    
    private func setupDateLabel() {
        self.dateLabel.text = "2021.07.21"
        self.dateLabel.textColor = .black_60
        self.dateLabel.font = UIFont(name: FontName.montserrat_medium, size: 10)
        self.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.timeLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(self.timeLabel)
        }
    }
    
    private func setupPhotoView() {
        self.photoView.image = UIImage(named: "photo_default")
        self.photoView.contentMode = .scaleAspectFill
        self.photoView.layer.cornerRadius = 16
        self.photoView.clipsToBounds = true
        self.addSubview(self.photoView)
        
        self.photoView.snp.makeConstraints {
            $0.top.equalTo(self.timeLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
    }
    
    private func setupEnrollPhotoButton() {
        self.enrollPhotoButton.setImage(UIImage(named: "enroll_photo"), for: .normal)
        self.enrollPhotoButton.contentMode = .scaleAspectFit
        self.photoView.addSubview(self.enrollPhotoButton)
        
        self.enrollPhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18)
            $0.height.equalToSuperview().multipliedBy(0.1625)
            $0.width.equalTo(self.enrollPhotoButton.snp.height).multipliedBy(4)
        }
    }
    
    private func setupHabitTextView() {
        self.habitTextView.borderWidth = 0.5
        self.habitTextView.borderColor = .gray
        self.addSubview(self.habitTextView)
        
        self.habitTextView.snp.makeConstraints {
            $0.top.equalTo(self.photoView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
            $0.bottom.equalToSuperview()
        }
    }
}
