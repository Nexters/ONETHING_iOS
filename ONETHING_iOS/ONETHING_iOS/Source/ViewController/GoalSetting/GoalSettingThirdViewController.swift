//
//  GoalSettingThirdViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import RxCocoa
import RxSwift
import UIKit

final class GoalSettingThirdViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.setupLabels()
        self.setupAlarmSettingView()
        self.setupPostponeSettingView()
        self.setupDatePicker()
        self.setupCountPicker()
        self.bindButtons()
        self.observeViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.nextLabelBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
        self.datePickerBottomConstraint.constant = 45 + DeviceInfo.safeAreaBottomInset
        self.countPickerBottomConstraint.constant = 45 + DeviceInfo.safeAreaBottomInset
    }
    
    func setHabitTitle(_ habitTitle: String) {
        self.viewModel.updateHabitTitle(habitTitle)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        self.dimView.showCrossDissolve()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.dimView.hideCrossDissolve()
    }
    
    private func setupLabels() {
        let secondLineTitle = "알림과 미룸 벌칙을"
        
        guard let pretendard_medium = UIFont.createFont(type: .pretendard(weight: .medium), size: 26) else { return }
        guard let pretendard_bold = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        
        guard let firstSubRange = secondLineTitle.range(of: "알림") else { return }
        guard let secondSubRange = secondLineTitle.range(of: "미룸 벌칙") else { return }
        
        let mainAttribute: [NSAttributedString.Key: Any] = [.font: pretendard_medium,
                                                            .foregroundColor: UIColor.black_100]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: pretendard_bold,
                                                            .foregroundColor: UIColor.black_100]
        
        let attributeText = NSMutableAttributedString(string: secondLineTitle, attributes: mainAttribute)
        attributeText.addAttributes(subAttributes, range: firstSubRange)
        attributeText.addAttributes(subAttributes, range: secondSubRange)
        self.titleSecondLineLabel.attributedText = attributeText
    }
    
    private func setupAlarmSettingView() {
        guard let alarmSettingView = self.alarmSettingView else { return }
        alarmSettingView.delegate = self
        self.alarmSettingContainerView.addSubview(alarmSettingView)
        
        alarmSettingView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setupPostponeSettingView() {
        guard let postponeTodoView = self.postponeTodoView else { return }
        postponeTodoView.delegate = self
        self.postponeTodoContainerView.addSubview(postponeTodoView)
        
        postponeTodoView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setupDatePicker() {
        self.datePicker.setValue(UIColor.white, forKey: "backgroundColor")
        self.datePicker.locale = Locale(identifier: "ko_KR")
        
        self.datePicker.rx.controlEvent(.valueChanged).observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.updatePushDate(self.datePicker.date)
        }).disposed(by: self.disposeBag)
    }
    
    private func setupCountPicker() {
        self.countPicker.setValue(UIColor.white, forKey: "backgroundColor")
        self.countPicker.dataSource = self
        self.countPicker.delegate = self
        
        self.countPicker.rx.itemSelected.observeOnMain(onNext: { [weak self] row, _ in
            self?.viewModel.updatePostponeCount(row + 1)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.startButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.pushGoalFinishController()
        }).disposed(by: self.disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.observeOnMain(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.hideDatePicker()
            self?.hideCountPicker()
        }).disposed(by: self.disposeBag)
        self.dimView.addGestureRecognizer(tapGesture)
        
        self.datePickerCompleteButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.hideDatePicker()
        }).disposed(by: self.disposeBag)
        
        self.countPickerCompleteButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            self?.view.endEditing(true)
            self?.hideCountPicker()
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.pushDateRelay.observeOnMain(onNext: { [weak self] date in
            self?.alarmSettingView?.updateDate(date)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.postponeTodoCountRelay.observeOnMain(onNext: { [weak self] count in
            self?.postponeTodoView?.updateCount(count)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.enableSubject.observeOnMain(onNext: { [weak self] enable in
            self?.startButton.backgroundColor = enable ? .black_100 : .black_40
            self?.startButton.isUserInteractionEnabled = enable
            self?.startLabel.textColor = enable ? .black_5 : .black_80
        }).disposed(by: self.disposeBag)
    }
    
    private func pushGoalFinishController() {
        let viewController = GoalSettingFinishViewController.instantiateViewController(from: .goalSetting)
        
        guard let goalSettingFinishController = viewController else { return }
        let habitTitle = self.viewModel.habitTitle
        let postponeTodo = self.viewModel.postponeTodo
        let pushTime = self.viewModel.pushDateRelay.value
        let postponeTodoCount = self.viewModel.postponeTodoCountRelay.value
        
        goalSettingFinishController.setHabitInformation(habitTitle, postponeTodo, pushTime, postponeTodoCount)
        self.navigationController?.pushViewController(goalSettingFinishController, animated: true)
    }
    
    private func showDatePicker() {
        self.dimView.showCrossDissolve()
        self.datePickerContainerView.isHidden = false
        self.datePickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1) {
            self.datePickerContainerView.transform = .identity
        }
    }
    
    private func hideDatePicker() {
        self.dimView.hideCrossDissolve()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, animations: {
            self.datePickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { [weak self] _ in
            self?.datePickerContainerView.isHidden = true
        })
    }
    
    private func showCountPicker() {
        self.dimView.showCrossDissolve()
        self.countPickerContainerView.isHidden = false
        self.countPickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1) {
            self.countPickerContainerView.transform = .identity
        }
    }
    
    private func hideCountPicker() {
        self.dimView.hideCrossDissolve()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, animations: {
            self.countPickerContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { [weak self] _ in
            self?.countPickerContainerView.isHidden = true
        })
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingThirdViewModel()

    private let alarmSettingView: AlarmSettingView? = UIView.createFromNib()
    private let postponeTodoView: PostponeTodoView? = UIView.createFromNib()
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleSecondLineLabel: UILabel!
    @IBOutlet private weak var titleLastLineLabel: UILabel!
    
    @IBOutlet private weak var alarmSettingContainerView: UIView!
    @IBOutlet private weak var postponeTodoContainerView: UIView!
    
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var nextLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var dimView: UIView!
    @IBOutlet private weak var datePickerContainerView: UIView!
    @IBOutlet private weak var datePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var datePickerCompleteButton: UIButton!
    
    @IBOutlet private weak var countPickerContainerView: UIView!
    @IBOutlet private weak var countPicker: UIPickerView!
    @IBOutlet private weak var countPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var countPickerCompleteButton: UIButton!
}

extension GoalSettingThirdViewController: AlarmSettingViewDelegate {
    
    func alarmSettingViewDidTapTime(_ alarmSettingView: AlarmSettingView) {
        self.showDatePicker()
    }
    
}

extension GoalSettingThirdViewController: PostponeTodoViewDelegate {
    
    func postponeTodoView(_ postponeTodoView: PostponeTodoView, didEditedText text: String) {
        self.viewModel.updatePostponeTodo(text)
    }
    
    func postponeTodoViewDidTapCount(_ postponeTodoView: PostponeTodoView) {
        self.showCountPicker()
    }

}

extension GoalSettingThirdViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    
}

extension GoalSettingThirdViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
}
