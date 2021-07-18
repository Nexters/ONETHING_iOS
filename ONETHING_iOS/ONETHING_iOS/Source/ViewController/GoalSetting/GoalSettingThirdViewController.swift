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
        self.setupAlarmSettingView()
        self.setupProgressView()
        self.bindButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.nextLabelBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 2
        progressView.currentProgressColor = .black_100
        progressView.totalProgressColor = .black_20
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLastLineLabel.snp.trailing).offset(10)
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
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingThirdViewModel()

    private let progressView: GoalProgressView? = UIView.createFromNib()
    private let alarmSettingView: AlarmSettingView? = UIView.createFromNib()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleLastLineLabel: UILabel!
    @IBOutlet private weak var alarmSettingContainerView: UIView!
    
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var nextLabelBottomConstraint: NSLayoutConstraint!
    
}

extension GoalSettingThirdViewController: AlarmSettingViewDelegate {
    
    func alarmSettingViewDidTapTime(_ alarmSettingView: AlarmSettingView) {
        #warning("Date Picker 추가")
    }
    
}
