//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class HabitWrittenViewController: BaseViewController {
    private let dailyHabitView = DailyHabitView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDailyHabitView()
    }
    
    private func setupView() {
        self.view.cornerRadius = 50
    }
    
    private func setupDailyHabitView() {
        self.view.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
}
