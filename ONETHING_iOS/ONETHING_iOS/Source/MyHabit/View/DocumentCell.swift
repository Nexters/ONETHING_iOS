//
//  DocumentCell.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

final class DocumentCell: UICollectionViewCell {
    private let dayLabel = UILabel()
    private let statusLabel = UILabel()
    
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 16
        self.backgroundColor = .black_5
        
        self.contentView.addSubview(self.dayLabel)
        self.contentView.addSubview(self.statusLabel)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.contentLabel)
        
        self.setupDayLabel()
        self.setupStatusLabel()
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupContentLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dayLabel.text = nil
        self.statusLabel.text = nil
        self.dateLabel.text = nil
        self.timeLabel.text = nil
        self.contentLabel.text = nil
    }
    
    func configure(order: Int, sentence sentenceForDelay: String, viewModel: DailyHabitResponseModel) {
        self.dayLabel.text = "\(order)일차"
        self.statusLabel.text = viewModel.statusText
        self.statusLabel.textColor = viewModel.statusColor
        self.dateLabel.text = viewModel.dateText
        self.timeLabel.text = viewModel.timeText
        self.contentLabel.text = viewModel.content ?? sentenceForDelay
    }
    
    private func setupDayLabel() {
        self.dayLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .extraBold), size: 12)
            $0.textColor = .black_100
        }
        
        self.dayLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
        }
    }
    
    private func setupStatusLabel() {
        self.statusLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .extraBold), size: 12)
            $0.textColor = .red_default
        }
        
        self.statusLabel.snp.makeConstraints {
            $0.leading.equalTo(self.dayLabel.snp.trailing).offset(5)
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    private func setupTimeLabel() {
        self.timeLabel.textColor = .black_40
        self.timeLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupDateLabel() {
        self.dateLabel.textColor = .black_60
        self.dateLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
        
        self.dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.trailing.equalTo(self.timeLabel.snp.leading).offset(-6)
        }
    }
    
    private func setupContentLabel() {
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
        
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.dayLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
