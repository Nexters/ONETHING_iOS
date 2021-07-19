//
//  GoalSettingSecondViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/17.
//

import RxCocoa
import RxSwift
import UIKit

final class GoalSettingSecondViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardDismissTapGesture()
        self.setupTextField()
        self.bindButtons()
        self.bindTextField()
        self.observeEnableNext()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.directSetButtonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func setupTextField() {
        guard let pretendardFont = UIFont(name: FontName.pretendard_semibold, size: 20) else { return }
        
        let attributePlaceHolderText = NSAttributedString(string: "매일 스쿼트 한 세트하기",
                                                          attributes: [.font: pretendardFont,
                                                                       .foregroundColor: UIColor.black_20])
        self.habbitTextField.attributedPlaceholder = attributePlaceHolderText
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindTextField() {
        self.habbitTextField.rx.text.orEmpty.observeOnMain(onNext: { [weak self] text in
            guard let self = self else { return }
            guard text.count <= GoalSettingSecondViewModel.maxInputCount else {
                self.habbitTextField.text?.removeLast()
                return
            }
            
            self.habbitInputCountLabel.text = "\(text.count) / \(GoalSettingSecondViewModel.maxInputCount)"
            self.viewModel.checkProccessable(text)
        }).disposed(by: self.disposeBag)
    }
    
    private func observeEnableNext() {
        self.viewModel.enableNextSubject.observeOnMain(onNext: { [weak self] enable in
            self?.directSetButton.backgroundColor = enable ? .black_100 : .black_40
            self?.directSetButton.isUserInteractionEnabled = enable
            self?.directSetLabel.textColor = enable ? .black_5 : .black_80
        }).disposed(by: self.disposeBag)
    }

    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingSecondViewModel()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var habbitTextField: UITextField!
    @IBOutlet private weak var habbitInputCountLabel: UILabel!
    @IBOutlet private weak var directSetButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var directSetButton: UIButton!
    @IBOutlet private weak var directSetLabel: UILabel!
    
}
