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
        self.setupProgressView()
        self.setupDatePicker()
        self.bindButtons()
        self.observeViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.nextLabelBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
        self.datePickerBottomConstraint.constant = 45 + DeviceInfo.safeAreaBottomInset
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
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 2
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
    
        #warning("제거 예정 테스트용")
        self.testCompleteButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.hideDatePicker()
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
        }).disposed(by: self.disposeBag)
        self.dimView.addGestureRecognizer(tapGesture)
    }
    
    private func observeViewModel() {
        self.viewModel.pushDateRelay.observeOnMain(onNext: { [weak self] date in
            self?.alarmSettingView?.updateDate(date)
        }).disposed(by: self.disposeBag)
    }
    
    private func pushGoalFinishController() {
        guard let viewController = GoalSettingFinishViewController.instantiateViewController(from: StoryboardName.goalSetting) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingThirdViewModel()

    private let progressView: GoalProgressView? = UIView.createFromNib()
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
    #warning("테스트용 삭제 예정")
    @IBOutlet private weak var testCompleteButton: UIButton!
    
}

extension GoalSettingThirdViewController: AlarmSettingViewDelegate {
    
    func alarmSettingViewDidTapTime(_ alarmSettingView: AlarmSettingView) {
        self.showDatePicker()
    }
    
}

extension GoalSettingThirdViewController: PostponeTodoViewDelegate {
    
    func postponeTodoView(_ postponeTodoView: PostponeTodoView, didEditedText text: String) {
        #warning("추가 예정")
        print("Here")
    }
    
    func postponeTodoViewDidTapCount(_ postponeTodoView: PostponeTodoView) {
        #warning("UIPicker 추가")
        print("Here1")
    }

}
