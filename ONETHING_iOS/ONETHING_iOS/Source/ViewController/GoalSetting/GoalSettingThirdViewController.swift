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
        self.addKeyboardDismissTapGesture()
        self.setupLabels()
        self.setupAlarmSettingView()
        self.setupPostponeSettingView()
        self.setupProgressView()
        self.bindButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.nextLabelBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func setupLabels() {
        let secondLineTitle = "알림과 미룸 벌칙을"
        
        guard let pretendard_medium = UIFont(name: FontName.pretendard_medium, size: 26) else { return }
        guard let pretendard_bold = UIFont(name: FontName.pretendard_bold, size: 26) else { return }
        
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
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.startButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.pushGoalFinishController()
        }).disposed(by: self.disposeBag)
    }
    
    private func pushGoalFinishController() {
        guard let viewController = GoalSettingFinishViewController.instantiateViewController(from: StoryboardName.goalSetting) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
}

extension GoalSettingThirdViewController: AlarmSettingViewDelegate {
    
    func alarmSettingViewDidTapTime(_ alarmSettingView: AlarmSettingView) {
        #warning("Date Picker 추가")
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
