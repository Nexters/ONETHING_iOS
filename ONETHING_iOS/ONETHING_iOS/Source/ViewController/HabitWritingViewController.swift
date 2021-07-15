//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private let stampButton = StampButton()
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        configureTitleLabel()
        configureStampButton()
    }
    
    @objc private func backButtonDidTouch(button: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureBackButton() {
        self.backButton.setImage(UIImage(named: "arrow_btn"), for: .normal)
        self.backButton.contentMode = .scaleAspectFit
        self.backButton.addTarget(self, action: #selector(backButtonDidTouch(button:)), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(62)
            $0.leading.equalToSuperview().inset(34)
            $0.width.equalTo(12)
            $0.height.equalTo(24)
        }
    }

    private func configureTitleLabel() {
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        self.titleLabel.text = "오늘의\n성공도장을\n찍어볼까요?"
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(41)
            $0.top.equalTo(self.backButton.snp.bottom).offset(15)
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
