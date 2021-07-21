//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class HabitWrittenViewController: BaseViewController {
    private let dailyHabitView = DailyHabitView()
    private let upperStampView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUpperStampView()
        setupDailyHabitView()
    }
    
    private func setupView() {
        self.view.cornerRadius = 40
    }
    
    private func setupUpperStampView() {
        self.upperStampView.contentMode = .scaleAspectFit
        self.upperStampView.image = Stamp.beige.defaultImage
        
        self.view.addSubview(self.upperStampView)
        self.upperStampView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-28)
            $0.height.width.equalTo(70)
            $0.leading.equalToSuperview().inset(32)
        }
    }
    
    private func setupDailyHabitView() {
        self.view.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
}
