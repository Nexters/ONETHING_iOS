//
//  HabitLogViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

import Then
import RxSwift

final class HabitWrittenViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private let dayLabel = UILabel()
    private let statusLabel = UILabel()
    private let dailyHabitView = DailyHabitView()
    private let upperStampButton = UIButton()
    private var panGestureManager: PanGestureRecognizerManager?
    
    private var timerForSwipe: Timer?
    private var panGestureState: UIPanGestureRecognizer.State?
    
    private var height: CGFloat?
    private var originMinY: CGFloat?
    private var originCenter: CGPoint?
    
    private let disposeBag = DisposeBag()
    
    var viewModel: HabitWrittenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.cornerRadius = 40
        self.setupPanGesture()
        self.addSubviews()
        self.setupUpperStampView()
        self.setupDayLabel()
        self.setupStatusLabel()
        self.setupDailyHabitView()
        
        self.updateViewsWithViewModel()
        self.viewModel?.requestHabitImageRx()
            .bind { [weak self] in self?.dailyHabitView.update(photoImage:$0) }
            .disposed(by: self.disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.height = UIScreen.main.bounds.height - self.view.frame.minY
        self.originMinY = self.view.frame.minY
        self.originCenter = self.view.center
    }
    
    private func setupPanGesture() {
        self.panGestureManager = PanGestureRecognizerManager(view: self.view, direction: .down)
        self.panGestureManager?.panGestureAction = { [weak self] panGesture in
            self?.handlePanGestureByState(panGesture)
        }
    }
    
    func didMove(toViewController viewController: UIViewController) {
        viewController.tabBarController?.tabBar.isHidden = true
        viewController.addChild(self)
        viewController.view.addSubview(self.view)
        
        self.view.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(DeviceInfo.screenHeight * 0.6)
            $0.bottom.equalToSuperview()
        })
        
        self.view.transform = CGAffineTransform(translationX: 0, y: DeviceInfo.screenHeight)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
        
        self.didMove(toParent: viewController)
    }
    
    @objc func removeFromParentVC() {
        self.parent?.tabBarController?.tabBar.isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: DeviceInfo.screenHeight)
                (self.parent as? HomeViewController)?.hideDimView()
            },
            completion: { _ in
                self.upperStampButton.isHidden = true
                (self.parent as? HomeViewController)?.removeDimRecognizer()
                self.willMove(toParent: nil)
                self.removeFromParent()
                self.view.removeFromSuperview()
            }
        )
    }
    
    private func handlePanGestureByState(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
            case .ended:
                self.routeToHomeOrReturnOriginCenter()
            default:
                self.updateStateAndTimerForSwipe(state: panGesture.state)
                self.panGestureManager?.changeCenterDuring(panGesture: panGesture, view: panGesture.view)
        }
    }
    
    // NOTE: 마지막 state가 ended 가 아닌 changed로 그대로 끝난 경우에 대비하기 위해 사용합니다.
    private func updateStateAndTimerForSwipe(state: UIPanGestureRecognizer.State) {
        self.timerForSwipe?.invalidate()
        
        self.panGestureState = state
        self.timerForSwipe = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            guard self.panGestureState == .changed else { return }
            
            self.routeToHomeOrReturnOriginCenter()
        })
    }
    
    private func routeToHomeOrReturnOriginCenter() {
        guard let height = self.height, let originMinY = self.originMinY else {
            self.removeFromParentVC()
            return
        }
        
        let thresholdY = originMinY + (height / 6.0)
        if self.view.frame.minY < thresholdY {
            self.returnToOriginCenter()
        } else {
            self.removeFromParentVC()
        }
    }
    
    private func returnToOriginCenter() {
        guard let originCenter = self.originCenter else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.center = originCenter
        })
    }
    
    private func addSubviews() {
        let views = [self.upperStampButton, self.dayLabel, self.statusLabel, self.dailyHabitView]
        views.forEach { self.view.addSubview($0) }
    }
    
    private func setupUpperStampView() {
        self.upperStampButton.contentMode = .scaleAspectFit
        
        self.upperStampButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-28)
            $0.height.width.equalTo(70)
            $0.leading.equalToSuperview().inset(32)
        }
    }
    
    private func setupDayLabel() {
        self.dayLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
            $0.textColor = .black_100
        }
        
        self.dayLabel.snp.makeConstraints {
            $0.leading.equalTo(self.upperStampButton.snp.trailing).offset(10)
            $0.lastBaseline.equalTo(self.dailyHabitView.dateLabel)
        }
    }
    
    private func setupStatusLabel() {
        self.statusLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
            $0.textColor = .red_default
        }
        
        self.statusLabel.snp.makeConstraints {
            $0.leading.equalTo(self.dayLabel.snp.trailing).offset(5)
            $0.lastBaseline.equalTo(self.dailyHabitView.dateLabel)
        }
    }
    
    private func setupDailyHabitView() {
        self.dailyHabitView.do {
            $0.enrollPhotoButton.isHidden = true
            $0.hidePlaceHolderLabelOfTextView()
            $0.hideTextCountLabelOfTextView()
            $0.dailyHabitViewCloseButtonDelegate = self
        }
        
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        self.dailyHabitView.setEditingEnable(false)
    }
    
    private func updateViewsWithViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        self.upperStampButton.setImage(viewModel.currentStampImage, for: .normal)
        self.upperStampButton.setImage(viewModel.currentStampImage, for: .highlighted)
        self.dayLabel.text = viewModel.dayText
        self.statusLabel.text = viewModel.statusText
        self.statusLabel.textColor = viewModel.statusColor
        self.dailyHabitView.update(with: viewModel)
    }
}

extension HabitWrittenViewController: DailyHabitViewCloseButtonDelegate {
    func dailyHabitViewDidTapCloseButton(_ dailyHabitView: DailyHabitView) {
        self.removeFromParentVC()
    }
}
