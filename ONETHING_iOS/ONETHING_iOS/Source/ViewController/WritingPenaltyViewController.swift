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
    private let warningLabel = UILabel()
    var viewModel: WritingPenaltyViewModel?
    
    weak var delegate: WritingPenaltyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardDismissTapGesture()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupPenaltyInfoView() {
        guard let penaltyInfoView = self.penaltyInfoView else { return }

        penaltyInfoView.do {
            $0.isUserInteractionEnabled = false
            $0.arrowImageView.isHidden = true
        }
        
        self.penaltyInfoContainerView.addSubview(penaltyInfoView)
        penaltyInfoView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            guard let penaltyInfoView = self.penaltyInfoView else { return }
            
            $0.top.equalTo(penaltyInfoView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(self.completeButton.snp.top).offset(-43)
        }
    }
    
    private func setupInnerStackView() {
        self.scrollView.addSubview(self.innerStackView)
        
        self.innerStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(self.innerStackView)
        }
    }
    
    private func setupWarningLabel() {
        self.warningLabel.do {
            $0.text = "*다짐 문장을 정확히 입력해 주세요!"
            $0.textColor = .red_default
            $0.font = UIFont.createFont(type: FontType.pretendard(weight: .regular), size: 12.0)
            $0.isHidden = true
        }
        
        self.view.addSubview(self.warningLabel)
        self.warningLabel.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.snp.bottom).offset(8.0)
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
        let dummyViews = (0..<4).map { _ in return UIView() }
        dummyViews.forEach { dummyView in
            self.innerStackView.addArrangedSubview(dummyView)
            dummyView.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.width.equalToSuperview()
            }
        }
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
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var completeLabel: UILabel!
}

// MARK: - UITextField Delegate Methods
extension WritingPenaltyViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isLast(textField: textField) {
            self.updateViewsByValidation()
        }
    }
    
    private func updateViewsByValidation() {
        let allValid = self.allValid
        
        self.enableOrDisableCompleteButton(allValid: allValid)
        self.showOrHideWarningLabel(allValid: allValid)
    }
    
    private func enableOrDisableCompleteButton(allValid: Bool) {
        self.completeButton.isUserInteractionEnabled = allValid ? true : false
        self.completeButton.backgroundColor = allValid ? .black_100 : .black_40
        self.completeLabel.textColor = allValid ? .white : .black_80
    }
    
    private func showOrHideWarningLabel(allValid: Bool) {
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
