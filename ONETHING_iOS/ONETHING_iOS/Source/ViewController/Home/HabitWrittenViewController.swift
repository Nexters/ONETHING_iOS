//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

import Then

protocol HabitWrittenViewControllerDelegate: AnyObject {
    func clearDimEffect()
}

final class HabitWrittenViewController: BaseViewController {
    private let dailyHabitView = DailyHabitView(hideCloseButton: false)
    private let upperStampButton = UIButton()
    weak var delegate: HabitWrittenViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupUpperStampView()
        self.setupDailyHabitView()
        self.addDownGestureRecognizer()
    }

    private func setupView() {
        self.view.cornerRadius = 40
    }
    
    private func setupUpperStampView() {
        self.upperStampButton.contentMode = .scaleAspectFit
        self.upperStampButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        
        self.view.addSubview(self.upperStampButton)
        self.upperStampButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-28)
            $0.height.width.equalTo(70)
            $0.leading.equalToSuperview().inset(32)
        }
    }
    
    private func setupDailyHabitView() {
        self.dailyHabitView.dailyHabitViewCloseButtonDelegate = self
        self.view.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    @objc private func dismissViewController() {
        self.delegate?.clearDimEffect()
        self.upperStampButton.isHidden = true
        super.dismiss(animated: true)
    }
    
    private func addDownGestureRecognizer() {
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe)).then {
            $0.direction = .down
        }
        
        self.view.addGestureRecognizer(downSwipeGestureRecognizer)
    }
    
    @objc private func didSwipe() {
        self.dismissViewController()
    }
    
    func update(upperStampImage image: UIImage?) {
        self.upperStampButton.setImage(image, for: .normal)
        self.upperStampButton.setImage(image, for: .highlighted)
    }
}

extension HabitWrittenViewController: DailyHabitViewCloseButtonDelegate {
    func closeButtonDidTouch(dailyHabitView: DailyHabitView) {
        self.dismissViewController()
    }
}
