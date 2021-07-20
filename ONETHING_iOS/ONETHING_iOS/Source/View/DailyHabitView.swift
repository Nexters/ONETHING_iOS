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
    private let habitTextView = HabitTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupPhotoView()
        self.setupHabitTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTimeLabel() {
        self.timeLabel.text = "5:05 PM"
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.top)
        }
    }
    
    private func setupDateLabel() {
        self.dateLabel.text = "2021.07.21"
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
    
    private func setupHabitTextView() {
        self.habitTextView.backgroundColor = .green
        self.addSubview(self.habitTextView)
        
        self.habitTextView.snp.makeConstraints {
            $0.top.equalTo(self.photoView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview()
        }
    }
}
