//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private var backBtnTitleView: BackBtnTitleView!
    private var completeButton: CompleteButton!
    private let dailyHabitInfoView = DailyHabitView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBackBtnTitleView()
        self.setupDailyHabitView()
        self.setupCompleteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupBackBtnTitleView() {
        self.backBtnTitleView = BackBtnTitleView(parentViewController: self)
        self.backBtnTitleView.update(title: "1일차")
        
        self.view.addSubview(self.backBtnTitleView)
        self.backBtnTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(self.backBtnTitleView.backButtonDiameter)
        }
    }
    
    private func setupDailyHabitView() {
        self.view.addSubview(self.dailyHabitInfoView)
        self.dailyHabitInfoView.snp.makeConstraints {
            $0.top.equalTo(self.backBtnTitleView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupCompleteButton() {
        self.completeButton = CompleteButton(parentViewController: self)
        
        self.view.addSubview(self.completeButton)
        let safeArea = self.view.safeAreaLayoutGuide
        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.width.equalTo(safeArea)
            $0.height.equalTo(83)
        }
    }
}
