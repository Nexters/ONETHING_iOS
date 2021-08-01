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
        self.setupLabels()
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
    
    func setHabitName(_ habitName: String) {
        self.viewModel.updateHabitName(habitName)
    }
    
    private func setupLabels() {
        guard let pretendard_medium = UIFont.createFont(type: .pretendard(weight: .medium), size: 26) else { return }
        guard let pretendard_bold = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        
        guard let firstSubRange = "66일 동안".range(of: "66일") else { return }
        guard let secondSubRange = "어떤 습관을".range(of: "어떤 습관") else { return }
        
        let mainAttribute: [NSAttributedString.Key: Any] = [.font: pretendard_medium,
                                                            .foregroundColor: UIColor.black_100]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: pretendard_bold,
                                                            .foregroundColor: UIColor.black_100]
        
        let firstLineAttributeText = NSMutableAttributedString(string: "66일 동안", attributes: mainAttribute)
        firstLineAttributeText.addAttributes(subAttributes, range: firstSubRange)
        self.titleFirstLineLabel.attributedText = firstLineAttributeText
        
        let secondLineAttributeText = NSMutableAttributedString(string: "어떤 습관을", attributes: mainAttribute)
        secondLineAttributeText.addAttributes(subAttributes, range: secondSubRange)
        self.titleSecondLineLabel.attributedText = secondLineAttributeText
    }
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 1
        progressView.currentProgressColor = .black_100
        progressView.totalProgressColor = .black_20
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            let screenRatio = DeviceInfo.screenWidth / 375
            make.width.equalTo(143 * screenRatio)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(self.titleStackView.snp.bottom)
            make.height.equalTo(14)
        }
    }
    
    private func setupTextField() {
        guard let pretendardFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 20) else { return }
        
        let attributePlaceHolderText = NSAttributedString(string: "매일 스쿼트 한 세트하기",
                                                          attributes: [.font: pretendardFont,
                                                                       .foregroundColor: UIColor.black_20])
        self.habbitTextField.attributedPlaceholder = attributePlaceHolderText
        if let habitName = self.viewModel.habitName {
            self.habbitTextField.text = habitName
            self.viewModel.checkProccessable(habitName)
        }
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
            
            self.viewModel.updateHabitName(text)
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
        guard let viewController = GoalSettingThirdViewController.instantiateViewController(from: .goalSetting) else { return }
        guard let habitName = self.viewModel.habitName else { return }
        viewController.setHabitTitle(habitName)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingSecondViewModel()
    
    private let progressView: GoalProgressView? = UIView.createFromNib()
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleFirstLineLabel: UILabel!
    @IBOutlet private weak var titleSecondLineLabel: UILabel!
    
    @IBOutlet private weak var habbitTextField: UITextField!
    @IBOutlet private weak var habbitInputCountLabel: UILabel!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextLabel: UILabel!
    
}
