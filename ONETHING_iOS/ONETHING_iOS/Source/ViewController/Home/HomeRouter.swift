//
//  HomeRouter.swift
//  ONETHING_iOS
//
//  Created by sdean on 2022/02/02.
//

import UIKit

protocol HomeRoutingLogic {
    func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel)
    func routeToHabitWritingViewController(with writingViewModel: HabitWritingViewModel)
    func routeToGoalSettingFirstViewController()
    func routeToSuccessPopupViewController()
    func routeToHabitEditingViewController()
    func showWriteLimitPopupView(with indexPath: IndexPath)
    func showDelayPopupView()
    func showFailPopupView()
}

final class HomeRouter: NSObject, HomeRoutingLogic, UIViewControllerTransitioningDelegate, HabitWrittenViewControllerDelegate, HabitWritingViewControllerDelegate {
    weak var viewController: HomeViewController?
    
    func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel) {
        guard let viewController = self.viewController else { return }

        viewController.backgroundDimView.showCrossDissolve(completedAlpha: viewController.backgroundDimView.completedAlpha)
        
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
            $0.viewModel = HabitWrittenViewModel(dailyHabitModel: dailyHabitModel)
            $0.delegate = self
        }
        viewController.present(habitWrittenViewController, animated: true)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HeightRatioPresentationController(
            heightRatio: 0.6,
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func habitWrittenViewControllerWillDismiss(_ habitWrittenViewController: HabitWrittenViewController) {
        guard let viewController = self.viewController else { return }
        
        viewController.backgroundDimView.hideCrossDissolve()
    }
    
    func routeToHabitWritingViewController(with writingViewModel: HabitWritingViewModel) {
        guard let viewController = self.viewController else { return }

        let habitWritingViewController = HabitWritingViewController().then {
            $0.delegate = self
            $0.viewModel = writingViewModel
        }
        
        viewController.navigationController?.isNavigationBarHidden = false
        viewController.navigationController?.navigationBar.isHidden = true
        viewController.navigationController?.pushViewController(habitWritingViewController, animated: true)
    }
    
    func update(currentDailyHabitModel: DailyHabitResponseModel) {
        guard let viewController = self.viewController else { return }
        
        let viewModel = viewController.viewModel
        viewModel.append(currentDailyHabitModel: currentDailyHabitModel)
        
        // 66일째 일일 습관 완료 후, 습관이 성공했을 때
        if viewModel.isHabitSuccess {
            viewModel.requestPassedHabitForSuccessOrFailView()
        }
    }
}

extension HomeRouter {
    func routeToGoalSettingFirstViewController() {
        guard let viewController = self.viewController else { return }
        guard let goalSettingFirstViewController = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting) else { return }
        
        let navigationController = UINavigationController(rootViewController: goalSettingFirstViewController).then {
            $0.modalPresentationStyle = .fullScreen
            $0.isNavigationBarHidden = true
        }
        
        viewController.present(navigationController, animated: true) {
            viewController.revealMainViewAndHideEmptyView()
        }
    }
}

extension HomeRouter: DelayPopupViewDelegate, FailPopupViewDelegate, WritingPenaltyViewControllerDelegate {
    func showWriteLimitPopupView(with indexPath: IndexPath) {
        guard let viewController = self.viewController,
              let tabbarController = viewController.tabBarController,
              let writeLimitPopupView: CustomPopupView = UIView.createFromNib() else { return }
        
        let viewModel = viewController.viewModel
        writeLimitPopupView.configure(attributedText: viewModel.limitMessage(with: indexPath),
                                      numberText: viewModel.numberText(with: indexPath),
                                      image: HabitCalendarCell.placeholderImage)
        writeLimitPopupView.show(in: tabbarController)
    }
    
    func showDelayPopupView() {
        guard let viewController = self.viewController,
              let delayPopupView: DelayPopupView = UIView.createFromNib(),
              let tabbarController = viewController.tabBarController else { return }
        
        viewController.backgroundDimView.showCrossDissolve(completedAlpha: viewController.backgroundDimView.completedAlpha)
        
        let viewModel = viewController.viewModel
        delayPopupView.delegate = self
        delayPopupView.configure(with: viewModel)
        delayPopupView.show(in: tabbarController, completion: {
            delayPopupView.animateShaking()
        })
    }
    
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView) {
        guard let viewModel = self.viewController?.viewModel else { return }
        
        viewModel.update(isGiveUp: true)
        self.showFailPopupView()
    }
    
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView) {
        guard let viewController = self.viewController else { return }
        
        viewController.backgroundDimView.isHidden = true
        viewController.delayPopupView = delayPopupView
        viewController.delayPopupView?.isHidden = true
        viewController.delayPopupView?.guideLabel.isHidden = true
        
        self.pushWritingPenaltyViewController()
    }
    
    private func pushWritingPenaltyViewController() {
        guard let viewController = self.viewController else { return }
        let viewModel = viewController.viewModel
        
        guard let writingPenaltyViewController = WritingPenaltyViewController.instantiateViewController(from: .writingPenalty),
              let habitId = viewModel.habitResponseModel?.habitId,
              let sentence = viewModel.habitResponseModel?.sentence,
              let penaltyCount = viewModel.habitResponseModel?.penaltyCount else { return }
        
        writingPenaltyViewController.delegate = self
        writingPenaltyViewController.viewModel = WritingPenaltyViewModel(
            habitID: habitId,
            sentence: sentence,
            penaltyCount: penaltyCount
        )
        viewController.navigationController?.pushViewController(writingPenaltyViewController, animated: true)
    }
    
    func showFailPopupView() {
        guard let viewController = self.viewController,
        let failPopupView: FailPopupView = UIView.createFromNib(),
        let tabbarController = viewController.tabBarController else { return }
        
        let viewModel = viewController.viewModel
        failPopupView.delegate = self
        failPopupView.configure(with: viewModel)
        failPopupView.show(in: tabbarController) {
            failPopupView.animateShaking()
        }
    }
    
    func failPopupViewDidTapCloseButton() {
        guard let viewController = self.viewController else { return }
        let viewModel = viewController.viewModel
        
        // unseen fail인 경우
        if viewModel.hasToCheckUnseen == false {
            guard let habitID = viewModel.habitResponseModel?.habitId else { return }
            
            viewModel.requestUnseenFailToBeFail(habitId: habitID) { _ in
                viewModel.requestHabitInProgress()
                viewModel.update(isGiveUp: false)
                viewController.backgroundDimView.hideCrossDissolve()
            }
            return
        }
        
        // 이전에 습관 그만하기 버튼을 눌렀던 경우
        viewModel.requestGiveup(completion: { _ in
            viewModel.requestHabitInProgress()
            viewModel.update(isGiveUp: false)
            viewController.backgroundDimView.hideCrossDissolve()
        })
    }
    
    func writingPenaltyViewControllerDidTapBackButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        guard let viewController = self.viewController else { return }
        
        viewController.backgroundDimView.isHidden = false
        viewController.delayPopupView?.isHidden = false
        viewController.delayPopupView?.guideLabel.isHidden = false
    }
    
    func writingPenaltyViewControllerDidTapCompleteButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        guard let viewController = self.viewController else { return }
        
        viewController.viewModel.requestHabitInProgress()
        viewController.delayPopupView?.hide()
    }
}

extension HomeRouter: HabitEditingViewControllerDelegate {
    func routeToHabitEditingViewController() {
        guard let viewController = self.viewController,
              let habitEditingViewController = HabitEditingViewController.instantiateViewController(from: .habitEdit)
        else { return }
        guard let habitInProgressModel = viewController.viewModel.habitResponseModel else { return }
        
        habitEditingViewController.delegate = self
        habitEditingViewController.viewModel = HabitEditViewModel(habitInProgressModel: habitInProgressModel)
        viewController.navigationController?.pushViewController(habitEditingViewController, animated: true)
    }
    
    func habitEditingViewControllerDidTapCompleteButton(_ habitEditingViewController: HabitEditingViewController) {
        guard let viewController = self.viewController else { return }
        guard let habitInProgressModel = habitEditingViewController.viewModel?.habitInProgressModel else { return }
        
        viewController.viewModel.update(habitInProgressModel: habitInProgressModel)
        viewController.habitInfoView.update(with: viewController.viewModel)
    }
}

extension HomeRouter: SuccessPopupViewControllerDelegate {
    func routeToSuccessPopupViewController() {
        guard let viewController = self.viewController else { return }
        guard let habitResponseModel = viewController.viewModel.habitResponseModel else { return }
        
        let successPopupViewController = SuccessPopupViewController().then {
            $0.delegate = self
            $0.modalPresentationStyle = .fullScreen
            $0.viewModel = SuccessPopupViewModel(habitResponseModel: habitResponseModel)
        }
        
        viewController.present(successPopupViewController, animated: true)
    }
    
    func successPopupViewControllerDidTapButton(_ viewController: SuccessPopupViewController) {
        guard let viewController = self.viewController else { return }
        let viewModel = viewController.viewModel
        guard let status: HabitResponseModel.HabitStatus = viewModel.habitResponseModel?.onethingHabitStatus
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