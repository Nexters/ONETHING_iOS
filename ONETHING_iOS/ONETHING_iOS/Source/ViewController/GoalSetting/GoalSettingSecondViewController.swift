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
        self.setupProgressView()
        self.setupTextField()
        self.bindButtons()
        self.bindTextField()
        self.observeEnableNext()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.nextButtonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 1
        progressView.currentProgressColor = .black_100
        progressView.totalProgressColor = .black_20
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(self.titleStackView.snp.bottom)
            make.height.equalTo(14)
        }
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
        
        self.nextButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.pushThirdGoalSettingController()
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
            self?.nextButton.backgroundColor = enable ? .black_100 : .black_40
            self?.nextButton.isUserInteractionEnabled = enable
            self?.nextLabel.textColor = enable ? .black_5 : .black_80
        }).disposed(by: self.disposeBag)
    }
    
    private func pushThirdGoalSettingController() {
        guard let viewController = GoalSettingThirdViewController.instantiateViewController(from: StoryboardName.goalSetting) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingSecondViewModel()
    
    private let progressView: GoalProgressView? = UIView.createFromNib()
    
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var habbitTextField: UITextField!
    @IBOutlet private weak var habbitInputCountLabel: UILabel!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextLabel: UILabel!
    
}
