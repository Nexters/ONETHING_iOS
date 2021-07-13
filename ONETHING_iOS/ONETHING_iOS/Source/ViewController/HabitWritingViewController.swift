//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private let stampButton = StampButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompletedButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureCompletedButton() {
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
