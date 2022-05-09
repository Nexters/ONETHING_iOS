//
//  WritingPenaltyViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/24.
//

import UIKit

import RxSwift
import RxCocoa
import SwiftUI

protocol WritingPenaltyViewControllerDelegate: AnyObject {
    func writingPenaltyViewControllerDidTapBackButton(_ writingPenaltyViewController: WritingPenaltyViewController)
    func writingPenaltyViewControllerDidTapCompleteButton(_ writingPenaltyViewController: WritingPenaltyViewController)
}

final class WritingPenaltyViewController: BaseViewController {
    private var penaltyTextableViews: [PenaltyTextableView] = []
    private let scrollView = WritingPenaltyScrollView()
    private let bottomConstantOfScrollView: CGFloat = 43.0
    private let innerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    private let warningLabel = UILabel()
    var viewModel: WritingPenaltyViewModel?
    
    weak var delegate: WritingPenaltyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardDismissTapGesture()
        self.addObserverForViewModel()
        self.addObserversForKeyboard()
        
        self.addSubViews()
        self.setupPenaltyInfoView()
        self.setupScrollView()
        self.setupInnerStackView()
        self.setupWarningLabel()
        self.bindButtons()
        self.updateViews(with: self.viewModel)
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.writingPenaltyViewControllerDidTapBackButton(self)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.completeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.viewModel?.putDelayPenaltyForCompleted(completion: { _ in
                self.delegate?.writingPenaltyViewControllerDidTapCompleteButton(self)
                self.navigationController?.popViewController(animated: true)
            })
        }).disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateLayoutOfScrollView()
    }
    
    private func updateLayoutOfScrollView() {
        if self.isInnerStackViewHeightHigherThanThreshold {
            self.scrollView.activeBottomConstraintOfScrollViewForBig()
            return
        }
        
        self.scrollView.activeHeightConstraintOfScrollViewForSmall()
    }
    
    private var isInnerStackViewHeightHigherThanThreshold: Bool {
        let innerStackViewHeight = self.innerStackView.frame.height
        let threshold = abs(self.scrollView.frame.minY - self.bottomView.frame.minY) - self.bottomConstantOfScrollView
        return innerStackViewHeight > threshold
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func addObserverForViewModel() {
        NotificationCenter.default.addObserver(
            forName: WritingPenaltyViewModel.Notification.userInputTextDidChange,
            object: nil,
            queue: nil
        ) { [weak self] notifiaction in
            self?.updateDelayPenaltyTextField(notifiaction)
        }
    }
    
    private func addObserversForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        self.scrollView.keyboardFrame = keyboardFrame
        self.scrollView.updateScrollViewWhenKeyboardShowIfNeeded()
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.updateLayoutOfScrollView()
    }
    
    private func addSubViews() {
        guard let penaltyInfoView = self.penaltyInfoView else { return }
        
        self.penaltyInfoContainerView.addSubview(penaltyInfoView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.innerStackView)
        self.view.addSubview(self.warningLabel)
    }
    
    private func setupPenaltyInfoView() {
        guard let penaltyInfoView = self.penaltyInfoView else { return }

        penaltyInfoView.do {
            $0.isUserInteractionEnabled = false
            $0.arrowImageView.isHidden = true
        }
        
        penaltyInfoView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        self.scrollView.snp.makeConstraints {
            guard let penaltyInfoView = self.penaltyInfoView else { return }
            
            $0.top.equalTo(penaltyInfoView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        self.scrollView.heightConstraintOfScrollViewAtFirst = self.scrollView.heightAnchor.constraint(equalTo: self.innerStackView.heightAnchor)
        self.scrollView.bottomConstraintOfScrollViewIfLarge = self.scrollView.bottomAnchor.constraint(
            equalTo: self.bottomView.topAnchor,
            constant: -self.bottomConstantOfScrollView
        )
        self.scrollView.activeHeightConstraintOfScrollViewForSmall()
        self.scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(self.innerStackView)
        }
    }
    
    private func setupInnerStackView() {
        self.innerStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupWarningLabel() {
        self.warningLabel.do {
            $0.text = "* 다짐 문장을 정확히 입력해 주세요!"
            $0.textColor = .red_default
            $0.font = UIFont.createFont(type: FontType.pretendard(weight: .regular), size: 12.0)
            $0.isHidden = true
        }
        
        self.warningLabel.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.snp.bottom).offset(10.0)
            $0.leading.trailing.equalTo(self.scrollView)
        }
    }
    
    private func updateViews(with viewModel: WritingPenaltyViewModel?) {
        guard let viewModel = viewModel else { return }
        
        self.configurePenaltyTextableViews(with: viewModel.penaltyCount, sentence: viewModel.sentence)
        self.penaltyInfoView?.updateCount(with: viewModel)
        self.penaltyInfoView?.update(sentence: viewModel.sentence)
    }
    
    private func configurePenaltyTextableViews(with count: Int, sentence: String) {
        self.penaltyTextableViews = (0..<count).compactMap { _ -> PenaltyTextableView? in
            let view: PenaltyTextableView? = UIView.createFromNib()
            view?.placeholderLabel.text = sentence
            return view
        }
        
        self.configureDelayPenaltyTextFields()
        self.addPenaltyTextableViewsToInnerStackView()
    }
    
    private func configureDelayPenaltyTextFields() {
        self.delayPenaltyTextFields.forEach { $0.delegate = self }
    }
    
    private var delayPenaltyTextFields: [DelayPenaltyTextField] {
        return self.penaltyTextableViews.compactMap({ $0.textField })
    }
    
    private func updateDelayPenaltyTextField(_ notification: Notification) {
        guard let targetIndex = notification.userInfo?["targetIndex"] as? Int,
              let updatedText = notification.userInfo?["updatedText"] as? String?
        else { return }
        
        guard self.delayPenaltyTextFields[safe: targetIndex] != nil
        else { return }
        
        self.delayPenaltyTextFields[targetIndex].text = updatedText
    }
    
    private func addPenaltyTextableViewsToInnerStackView() {
        self.penaltyTextableViews.forEach {
            self.innerStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.width.equalToSuperview()
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var penaltyInfoContainerView: UIView!
    private let penaltyInfoView: PenaltyInfoView? = UIView.createFromNib()
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var completeLabel: UILabel!
}

// MARK: - UITextField Delegate Methods
extension WritingPenaltyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delayPenaltyTextField = textField as? DelayPenaltyTextField,
              let currentIndex = self.delayPenaltyTextFields.firstIndex(of: delayPenaltyTextField)
        else { return }
        
        self.viewModel?.updateUserInputText(at: currentIndex, textField.text)
        self.updateViewsByValidationIfIsLast(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let currentTextField = textField as? DelayPenaltyTextField
        else { return true }
        
        self.handleFirstResponder(with: currentTextField)
        self.updateViewsByValidationIfIsLast(textField)
        return true
    }
    
    private func handleFirstResponder(with currentTextField: DelayPenaltyTextField) {
        guard self.isLast(textField: currentTextField) == false else {
            self.firstInvalidTextFieldBecomeFirstResponderOrDismissKeyboard()
            return
        }
        
        self.nextFieldBecomeFirstResponder(with: currentTextField)
        return
    }
    
    private func firstInvalidTextFieldBecomeFirstResponderOrDismissKeyboard() {
        guard let allValid = self.viewModel?.allValid else { return }
        if allValid {
            self.view.endEditing(true)
            return
        }
        
        self.becomeFirstResponderForFirstInvalidTextField()
    }
    
    private func becomeFirstResponderForFirstInvalidTextField() {
        guard let firstInvalidTextField = self.penaltyTextableViews.enumerated().filter({ (index, penaltyTextableView) in
            return self.viewModel?.isValid(at: index) == false
        }).compactMap({ $1 }).compactMap({ $0.textField }).first
        else { return }
        
        firstInvalidTextField.becomeFirstResponder()
    }
    
    private func nextFieldBecomeFirstResponder(with currentTextField: DelayPenaltyTextField) {
        guard let indexOfCurrentTextField = self.delayPenaltyTextFields.firstIndex(of: currentTextField)
        else { return }
        
        let nextIndex = self.delayPenaltyTextFields.index(after: indexOfCurrentTextField)
        guard nextIndex != self.delayPenaltyTextFields.endIndex else { return }
        
        let nextTextField = self.delayPenaltyTextFields[safe: nextIndex]
        nextTextField?.becomeFirstResponder()
    }
    
    private func isLast(textField: UITextField) -> Bool {
        return textField === self.delayPenaltyTextFields.last
    }
    
    private func updateViewsByValidationIfIsLast(_ textField: UITextField) {
        guard self.isLast(textField: textField) else { return }
        
        self.updateViewsByValidation()
    }
    
    private func updateViewsByValidation() {
        guard let allValid = self.viewModel?.allValid else { return }
        
        self.enableOrDisableCompleteButton(with: allValid)
        self.representAreInvalidTextFieldsIfNeeded(with: allValid)
        self.showOrHideWarningLabel(with: allValid)
    }
    
    private func enableOrDisableCompleteButton(with allValid: Bool) {
        self.completeButton.isUserInteractionEnabled = allValid ? true : false
        self.completeButton.backgroundColor = allValid ? .black_100 : .black_40
        self.completeLabel.textColor = allValid ? .white : .black_80
    }
    
    private func representAreInvalidTextFieldsIfNeeded(with allValid: Bool) {
        let invalidTextFields = self.penaltyTextableViews.enumerated().filter({ (index, penaltyTextableView) in
            return self.viewModel?.isValid(at: index) == false
        }).compactMap{ $1 }.compactMap { $0.textField }
        
        let isOnlyOneInvalidTextField = invalidTextFields.count == 1
        if isOnlyOneInvalidTextField {
            self.representIsInvalidIfOnlyOne(with: invalidTextFields)
            return
        }
        
        self.representAreInvalid(textfields: invalidTextFields)
    }
    
    private func representIsInvalidIfOnlyOne(with invalidTextFields: [DelayPenaltyTextField]) {
        guard let textField = invalidTextFields.first else { return }
        
        textField.representIsInvalidIfIsFirst()
    }
    
    private func representAreInvalid(textfields invalidTextFields: [DelayPenaltyTextField]) {
        invalidTextFields.enumerated().forEach { index, textField in
            let isFirst = index == 0
            if isFirst {
                textField.representIsInvalidIfIsFirst()
                return
            }
            
            textField.representIsInvalidIfIsNotFirst()
        }
    }
    
    private func showOrHideWarningLabel(with allValid: Bool) {
        self.warningLabel.isHidden = allValid ? true : false
    }
}
