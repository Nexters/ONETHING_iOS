//
//  HomeRouter.swift
//  ONETHING_iOS
//
//  Created by sdean on 2022/02/02.
//

import UIKit

import Then
import RxSwift

protocol HomeRoutingLogic {
    
    func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel)
    func routeToHabitWritingViewController(with writingViewModel: HabitWritingViewModel)
    func routeToGoalSettingFirstViewController()
    func routeToSuccessPopupViewController()
    func routeToHabitEditingViewController()
    func showWriteLimitPopupView(with indexPath: IndexPath)
    func showDelayPopupView()
    func showFailPopupView(reason: FailPopupView.FailReason)
}

final class HomeRouter: NSObject, HomeRoutingLogic, HabitWritingViewControllerDelegate {
    weak var viewController: HomeViewController?
    private let disposeBag = DisposeBag()
    
    func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel) {
        guard let homeViewController = self.viewController else { return }
        
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.viewModel = HabitWrittenViewModel(dailyHabitModel: dailyHabitModel)
        }
        
        homeViewController.do {
            $0.showDimView()
            let tapGestureForDimView = self.makeTapGestureRecognizerOfDimView(for: habitWrittenViewController)
            $0.addDimTapGestureRecognizer(tapGestureForDimView)
        }
        
        habitWrittenViewController.didMove(toViewController: homeViewController)
    }
    
    private func makeTapGestureRecognizerOfDimView(for habitWrittenViewController: HabitWrittenViewController) -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event
            .subscribe(onNext: { owner in
                habitWrittenViewController.removeFromParentVC()
            })
            .disposed(by: self.disposeBag)
        return tapGestureRecognizer
    }
    
    func routeToHabitWritingViewController(with writingViewModel: HabitWritingViewModel) {
        guard let homeViewController = self.viewController else { return }

        let habitWritingViewController = HabitWritingViewController().then {
            $0.delegate = self
            $0.viewModel = writingViewModel
        }
        
        homeViewController.navigationController?.isNavigationBarHidden = false
        homeViewController.navigationController?.navigationBar.isHidden = true
        homeViewController.navigationController?.pushViewController(habitWritingViewController, animated: true)
    }
    
    func update(currentDailyHabitModel: DailyHabitResponseModel) {
        guard let homeViewController = self.viewController else { return }
        
        let viewModel = homeViewController.viewModel
        viewModel.append(currentDailyHabitModel: currentDailyHabitModel)
        
        // 66일째 일일 습관 완료 후, 습관이 성공했을 때
        if viewModel.isHabitSuccess {
            viewModel.requestPassedHabitForSuccessOrFailView()
        }
    }
}

extension HomeRouter {
    func routeToGoalSettingFirstViewController() {
        guard let homeViewController = self.viewController,
              let goalSettingFirstViewController = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting)
        else { return }
        
        let navigationController = UINavigationController(rootViewController: goalSettingFirstViewController).then {
            $0.modalPresentationStyle = .fullScreen
            $0.isNavigationBarHidden = true
        }
        
        homeViewController.present(navigationController, animated: true) {
            homeViewController.revealMainViewAndHideEmptyView()
        }
    }
}

extension HomeRouter: FailPopupViewDelegate {
    func failPopupViewDidTapClose(_ failPopupview: FailPopupView) {
        guard let homeViewController = self.viewController else { return }
        
        let viewModel = homeViewController.viewModel
        viewModel.hasToCheckUnseen == false ? self.handleIsUnSeenFail() : self.handleIsGiveUp()
    }
    
    /// unseen fail인 경우
    private func handleIsUnSeenFail() {
        guard let homeViewController = self.viewController,
              let habitID = homeViewController.viewModel.habitInProgressModel?.habitId
        else { return }
        
        let viewModel = homeViewController.viewModel
        viewModel.requestUnseenFailToBeFail(habitId: habitID) { _ in
            homeViewController.mainTabBarController?.broadCastRequiredReload()
            viewModel.requestHabitInProgress()
            homeViewController.hideDimView()
        }
    }
    
    /// 이전에 습관 그만하기 버튼을 눌렀던 경우
    private func handleIsGiveUp() {
        guard let homeViewController = self.viewController else { return }
        let viewModel = homeViewController.viewModel
        
        viewModel.requestGiveup(completion: { _ in
            homeViewController.mainTabBarController?.broadCastRequiredReload()
            viewModel.requestHabitInProgress()
            homeViewController.hideDimView()
        })
    }
}

extension HomeRouter: DelayPopupViewDelegate, WritingPenaltyViewControllerDelegate {
    func showWriteLimitPopupView(with indexPath: IndexPath) {
        guard let homeViewController = self.viewController,
              let tabbarController = homeViewController.tabBarController,
              let writeLimitPopupView: CustomPopupView = UIView.createFromNib() else { return }
        
        let viewModel = homeViewController.viewModel
        writeLimitPopupView.configure(attributedText: viewModel.limitMessage(with: indexPath),
                                      numberText: viewModel.numberText(with: indexPath),
                                      image: HabitCalendarCell.placeholderImage)
        writeLimitPopupView.show(in: tabbarController)
    }
    
    func showDelayPopupView() {
        guard let homeViewController = self.viewController,
              let delayPopupView: DelayPopupView = UIView.createFromNib(),
              let tabbarController = homeViewController.tabBarController
        else { return }
        
        homeViewController.showDimView()
        delayPopupView.do { popupView in
            popupView.delegate = self
            popupView.configure(with: homeViewController.viewModel)
            popupView.show(in: tabbarController, completion: {
                popupView.animateShaking()
            })
        }
        
    }
    
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView) {
        guard let viewModel = self.viewController?.viewModel else { return }
        
        let warningPopupView = GiveUpWarningPopupView().then {
            $0.confirmAction = { [weak self] _ in
                delayPopupView.removeFromSuperView(0.1, completion: {
                    self?.showFailPopupView(reason: .giveup)
                })
            }
            $0.cancelAction = { popupView in
                popupView.backgroundDimView?.hideCrossDissolve()
                popupView.removeFromSuperview()
            }
            $0.update(with: viewModel)
        }
        warningPopupView.show(in: delayPopupView)
    }
    
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView) {
        guard let homeViewController = self.viewController else { return }
        
        homeViewController.hideDimView()
        homeViewController.delayPopupView = delayPopupView
        homeViewController.delayPopupView?.isHidden = true
        homeViewController.delayPopupView?.guideLabel.isHidden = true
        self.pushWritingPenaltyViewController()
    }
    
    private func pushWritingPenaltyViewController() {
        guard let homeViewController = self.viewController else { return }
        let viewModel = homeViewController.viewModel
        
        guard let writingPenaltyViewController = WritingPenaltyViewController.instantiateViewController(from: .writingPenalty),
              let habitId = viewModel.habitInProgressModel?.habitId,
              let sentence = viewModel.habitInProgressModel?.sentence,
              let penaltyCount = viewModel.habitInProgressModel?.penaltyCount else { return }
        
        writingPenaltyViewController.delegate = self
        writingPenaltyViewController.viewModel = WritingPenaltyViewModel(
            habitID: habitId,
            sentence: sentence,
            penaltyCount: penaltyCount
        )
        homeViewController.navigationController?.pushViewController(writingPenaltyViewController, animated: true)
    }
    
    func showFailPopupView(reason: FailPopupView.FailReason) {
        guard let homeViewController = self.viewController,
        let failPopupView: FailPopupView = UIView.createFromNib(),
        let tabbarController = homeViewController.tabBarController else { return }
        
        let viewModel = homeViewController.viewModel
        failPopupView.delegate = self
        failPopupView.configure(with: viewModel, reason: reason)
        failPopupView.show(in: tabbarController) {
            failPopupView.animateShaking()
        }
    }
    
    func writingPenaltyViewControllerDidTapBackButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        guard let homeViewController = self.viewController else { return }
        
        homeViewController.showDimView()
        homeViewController.delayPopupView?.isHidden = false
        homeViewController.delayPopupView?.guideLabel.isHidden = false
    }
    
    func writingPenaltyViewControllerDidTapCompleteButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        guard let homeViewController = self.viewController else { return }
        
        homeViewController.viewModel.requestHabitInProgress()
        homeViewController.delayPopupView?.removeFromSuperView()
    }
}

extension HomeRouter: HabitEditingViewControllerDelegate {
    func routeToHabitEditingViewController() {
        guard let homeViewController = self.viewController,
              let habitInProgressModel = homeViewController.viewModel.habitInProgressModel else { return }

        let storyboard = UIStoryboard(name: Storyboard.habitEdit.rawValue, bundle: nil)
        let identifier = String(describing: HabitEditingViewController.self)
        let habitEditingViewController = storyboard.instantiateViewController(
            identifier: identifier,
            creator: { coder -> HabitEditingViewController? in
                let viewController = HabitEditingViewController(coder: coder, viewModel: HabitEditViewModel(habitInProgressModel: habitInProgressModel))
                viewController?.delegate = self
                return viewController
            })
        
        homeViewController.navigationController?.pushViewController(habitEditingViewController, animated: true)
    }
    
    func habitEditingViewControllerDidTapCompleteButton(_ habitEditingViewController: HabitEditingViewController) {
        guard let homeViewController = self.viewController else { return }
        let habitInProgressModel = habitEditingViewController.viewModel.habitInProgressModel
        
        homeViewController.viewModel.update(habitInProgressModel: habitInProgressModel)
        homeViewController.habitInfoView.update(with: homeViewController.viewModel)
    }
}

extension HomeRouter: SuccessPopupViewControllerDelegate {
    func routeToSuccessPopupViewController() {
        guard let homeViewController = self.viewController else { return }
        guard let habitResponseModel = homeViewController.viewModel.habitInProgressModel else { return }
        
        let successPopupViewController = SuccessPopupViewController().then {
            $0.delegate = self
            $0.modalPresentationStyle = .fullScreen
            $0.viewModel = SuccessPopupViewModel(habitResponseModel: habitResponseModel)
        }
        
        homeViewController.present(successPopupViewController, animated: true)
    }
    
    func successPopupViewControllerDidTapButton(_ viewController: SuccessPopupViewController) {
        guard let homeViewController = self.viewController else { return }
        let viewModel = homeViewController.viewModel

        guard let status: HabitStatus = viewModel.habitInProgressModel?.onethingHabitStatus
        else { return }
        
        switch status {
            case .run:
                viewModel.requestHabitInProgress()
            case .unseenSuccess:
                viewModel.requestUnseenSuccessToBeSuccess { _ in
                    viewModel.requestHabitInProgress()
                }
            default:
                break
        }
    }
}
