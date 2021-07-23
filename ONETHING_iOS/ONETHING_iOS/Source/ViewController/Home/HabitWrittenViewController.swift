//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

protocol HabitWrittenViewControllerDelegate: AnyObject {
    func clearDimEffect()
}

final class HabitWrittenViewController: BaseViewController {
    private let dailyHabitView = DailyHabitView()
    private let upperStampView = UIButton()
    weak var delegate: HabitWrittenViewControllerDelegate?
    
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
        self.upperStampView.setImage(Stamp.beige.defaultImage, for: .normal)
        self.upperStampView.setImage(Stamp.beige.defaultImage, for: .highlighted)
        self.upperStampView.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        
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
    
    @objc private func dismissViewController() {
        self.delegate?.clearDimEffect()
        self.upperStampView.isHidden = true
        super.dismiss(animated: true, completion: nil)
    }
}
