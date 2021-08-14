//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

import Then
import RxSwift

protocol HabitWrittenViewControllerDelegate: AnyObject {
    func habitWrittenViewControllerWillDismiss(_ habitWrittenViewController: HabitWrittenViewController)
}

final class HabitWrittenViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private let dailyHabitView = DailyHabitView()
    private let upperStampButton = UIButton()
    private let disposeBag = DisposeBag()
    
    var viewModel: HabitWrittenViewModel?
    weak var delegate: HabitWrittenViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupUpperStampView()
        self.setupDailyHabitView()

        self.updateViewsWithViewModel()
        self.viewModel?.requestHabitImageRx()
            .bind { [weak self] in self?.dailyHabitView.update(photoImage:$0) }
            .disposed(by: self.disposeBag)
    }

    private func setupView() {
        self.view.cornerRadius = 40
    }
    
    private func setupUpperStampView() {
        self.upperStampButton.contentMode = .scaleAspectFit
        
        self.view.addSubview(self.upperStampButton)
        self.upperStampButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-28)
            $0.height.width.equalTo(70)
            $0.leading.equalToSuperview().inset(32)
        }
    }
    
    private func setupDailyHabitView() {
        self.dailyHabitView.do {
            $0.enrollPhotoButton.isHidden = true
            $0.hidePlaceHolderLabelOfTextView()
            $0.hideTextCountLabelOfTextView()
            $0.dailyHabitViewCloseButtonDelegate = self
        }
        
        self.view.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        self.dailyHabitView.setEditingEnable(false)
    }
    
    @objc private func dismissViewController() {
        self.delegate?.habitWrittenViewControllerWillDismiss(self)
        self.upperStampButton.isHidden = true
        super.dismiss(animated: true)
    }
    
    private func updateViewsWithViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        self.upperStampButton.setImage(self.viewModel?.currentStampImage, for: .normal)
        self.upperStampButton.setImage(self.viewModel?.currentStampImage, for: .highlighted)
        self.dailyHabitView.update(with: viewModel)
    }
}

extension HabitWrittenViewController: DailyHabitViewCloseButtonDelegate {
    func dailyHabitViewDidTapCloseButton(_ dailyHabitView: DailyHabitView) {
        self.dismissViewController()
    }
}
