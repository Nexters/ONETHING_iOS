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
    private let scrollView = UIScrollView()
    private let innerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    private var heightConstraintOfScrollViewAtFirst: NSLayoutConstraint?
    private var bottomConstraintOfScrollViewIfLarge: NSLayoutConstraint?
    
    private var keyboardFrame: CGRect?
    private var heightConstraintOfScrollViewWhenKeyboardShow: NSLayoutConstraint?
    
    private let warningLabel = UILabel()
    var viewModel: WritingPenaltyViewModel?
    
    weak var delegate: WritingPenaltyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardDismissTapGesture()
        self.addObservers()
        self.addSubViews()
        self.setupPenaltyInfoView()
        self.setupScrollView()
        self.setupInnerStackView()
        self.setupWarningLabel()
        
        self.bindButtons()
        self.updateViews(with: self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateLayoutOfScrollView()
    }
    
    private func activeHeightConstraintOfScrollViewForSmall() {
        self.heightConstraintOfScrollViewAtFirst?.isActive = true
        self.bottomConstraintOfScrollViewIfLarge?.isActive = false
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = false
    }
    
    private func activeBottomConstraintOfScrollViewForBig() {
        self.bottomConstraintOfScrollViewIfLarge?.isActive = true
        self.heightConstraintOfScrollViewAtFirst?.isActive = false
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = false
    }
    
    private func activeHeightConstraintOfScrollViewWhenKeyboardShow() {
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = true
        self.heightConstraintOfScrollViewAtFirst?.isActive = false
        self.bottomConstraintOfScrollViewIfLarge?.isActive = false
    }
    
    private func updateLayoutOfScrollView() {
        if self.isInnerStackViewHeightHigherThanThreshold {
            self.activeBottomConstraintOfScrollViewForBig()
            return
        }
        
        self.activeHeightConstraintOfScrollViewForSmall()
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
    
    private func addObservers() {
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
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        var keyboardFrame: CGRect
        if let frame = self.keyboardFrame {
            keyboardFrame = frame
        } else {
            guard let userInfo = notification.userInfo else { return }
            guard let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            keyboardFrame = frame
        }
        
        self.updateScrollViewWhenKeyboardShowIfNeeded(with: keyboardFrame)
    }
    
    private func updateScrollViewWhenKeyboardShowIfNeeded(with keyboardFrame: CGRect) {
        guard self.isScrollViewHeightHigherThanKeyboardThreshold(with: keyboardFrame) else { return }
        
        self.keyboardFrame = keyboardFrame
        
        let heightConstant = abs(self.scrollView.frame.minY - keyboardFrame.minY) - 10.0
        self.heightConstraintOfScrollViewWhenKeyboardShow = self.scrollView.heightAnchor.constraint(equalToConstant: heightConstant)
        self.activeHeightConstraintOfScrollViewWhenKeyboardShow()
    }
    
    private func isScrollViewHeightHigherThanKeyboardThreshold(with keyboardFrame: CGRect) -> Bool {
        let scrollViewViewHeight = self.scrollView.frame.height
        let keyBoardThreshold = abs(self.scrollView.frame.minY - keyboardFrame.minY)
        return scrollViewViewHeight > keyBoardThreshold
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.updateLayoutScrollViewWhenKeyboardHide()
    }
    
    private func updateLayoutScrollViewWhenKeyboardHide() {
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = false
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
        self.heightConstraintOfScrollViewAtFirst = self.scrollView.heightAnchor.constraint(equalTo: self.innerStackView.heightAnchor)
        self.bottomConstraintOfScrollViewIfLarge = self.scrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor,
                                                                                           constant: -self.bottomConstantOfScrollView)
        self.activeHeightConstraintOfScrollViewForSmall()
        self.scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(self.innerStackView)
        }
    }
    
    private let bottomConstantOfScrollView: CGFloat = 43.0
    
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
    
    func updateViews(with viewModel: WritingPenaltyViewModel?) {
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
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.isLast(textField: textField) {
            self.updateViewsByValidation()
        }
    }
    
    private func updateViewsByValidation() {
        let allValid = self.allValid
        
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
        if self.allValid {
            return
        }
        
        let invalidTextFields = self.penaltyTextableViews.filter({ penaltyTextableView in
            let placeholderLabelText = penaltyTextableView.placeholderLabel.text
            let currentTextFieldText = penaltyTextableView.textField.text?.trimmingLeadingAndTrailingSpaces()
            return placeholderLabelText != currentTextFieldText
        }).compactMap { $0.textField }
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let currentTextField = textField as? DelayPenaltyTextField
        else { return true }
        
        self.handleFirstResponder(with: currentTextField)
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
        if self.allValid {
            self.view.endEditing(true)
            return
        }
        
        self.becomeFirstResponderForFirstInvalidTextField()
    }
    
    private func becomeFirstResponderForFirstInvalidTextField() {
        guard let firstInvalidTextField = self.penaltyTextableViews.filter({ penaltyTextableView in
            let placeholderLabelText = penaltyTextableView.placeholderLabel.text
            let currentTextFieldText = penaltyTextableView.textField.text?.trimmingLeadingAndTrailingSpaces()
            
            return placeholderLabelText != currentTextFieldText
        }).first?.textField
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
    
    private var allValid: Bool {
        for textableView in self.penaltyTextableViews {
            let placeholderLabelText = textableView.placeholderLabel.text
            let currentTextFieldText = textableView.textField.text?.trimmingLeadingAndTrailingSpaces()
            
            if currentTextFieldText != placeholderLabelText {
                return false
            }
        }
        return true
    }
    
    private func isLast(textField: UITextField) -> Bool {
        return textField === self.delayPenaltyTextFields.last
    }
}
