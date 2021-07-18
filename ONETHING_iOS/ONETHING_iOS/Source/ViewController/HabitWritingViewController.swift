//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private var backBtnTitleView: BackBtnTitleView!
    private let stampButton = StampButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBtnTitleView()
        configureStampButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureBackBtnTitleView() {
        self.backBtnTitleView = BackBtnTitleView(frame: .zero, parentViewController: self)
        self.backBtnTitleView.update(title: "1일차")
        
        self.view.addSubview(self.backBtnTitleView)
        self.backBtnTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(self.backBtnTitleView.backButtonDiameter)
        }
    }
    
    private func configureStampButton() {
        self.stampButton.layer.borderWidth = 1
        self.stampButton.layer.borderColor = UIColor.red.cgColor
        
        self.view.addSubview(self.stampButton)
        let safeArea = self.view.safeAreaLayoutGuide
        self.stampButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(self.stampButton.snp.width)
            $0.bottom.equalTo(safeArea).inset(79)
        }
    }
}
