//
//  ViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Alamofire

final class HomeViewController: BaseViewController {
    private var barStyle: UIStatusBarStyle = .lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.barStyle }
    
    private let habitInfoView = HabitInfoView(frame: .zero, descriptionLabelTopConstant: 83)
    private var habitCalendarView = HabitCalendarView(
        frame: .zero, totalCellNumbers: HomeViewModel.defaultTotalDays, columnNumbers: 5
    )
    private let backgroundDimView = BackgroundDimView()
    private let homeEmptyView = HomeEmptyView().then { $0.isHidden = true }
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private weak var delayPopupView: DelayPopupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObserver()
        self.setupHabitInfoView()
        self.setupHabitCalendarView()
        self.setupBackgounndDimColorView()
        self.setupHomeEmptyView()
        self.bindButtons()
        self.observeViewModel()
        
        self.viewModel.requestHabitInProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func reloadContentsIfRequired() {
        super.reloadContentsIfRequired()
        
        self.viewModel.requestHabitInProgress()
    }
    
    override func clearContents() {
        self.viewModel.clearModels()
    }
    
    private func addObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.updateUserInform(_:)), name: .didUpdateUserInform, object: nil)
    }
    
    private func setupHabitInfoView() {
        self.view.addSubview(self.habitInfoView)
        
        self.habitInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(self.habitInfoView.snp.width).dividedBy(2)
        }
    }
    
    private func setupHabitCalendarView() {
        self.habitCalendarView.backgroundColor = .clear
        self.habitCalendarView.dataSource = self.viewModel
        self.habitCalendarView.registerCell(cellType: HabitCalendarCell.self)
        self.habitCalendarView.registerCell(cellType: UICollectionViewCell.self)
        self.habitCalendarView.delegate = self
        
        self.view.addSubview(self.habitCalendarView)
        self.habitCalendarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.habitInfoView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupBackgounndDimColorView() {
        self.tabBarController?.view.addSubview(self.backgroundDimView)
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupHomeEmptyView() {
        self.homeEmptyView.delegate = self
        self.view.addSubview(self.homeEmptyView)
        self.homeEmptyView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func observeViewModel() {
        // MARK: - related to In Progress Habit
        self.viewModel
            .habitResponseModelSubject
            .bind { [weak self] habitInProgressModel in
                guard let self = self else { return }
                guard let habitInProgressModel = habitInProgressModel else {
                    let hasToCheckUnseen = self.viewModel.hasToCheckUnseen
                    
                    hasToCheckUnseen == true ? self.viewModel.requestPassedHabitForSuccessOrFailView() : self.showEmptyViewAndHideMainView()
                    return
                }
                
                self.showMainViewAndHideEmptyView()
                self.viewModel.requestDailyHabits(habitId: habitInProgressModel.habitId)
                self.habitInfoView.update(with: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        self.viewModel
            .dailyHabitsSubject
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.habitInfoView.progressView.update(ratio: self.viewModel.progressRatio)
                self.habitCalendarView.reloadData()
                
                self.presentPopupViewIfNeeded(with: self.viewModel.habitResponseModel?.onethingHabitStatus)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel
            .currentIndexPathOfDailyHabitSubject
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.habitInfoView.progressView.update(ratio: self.viewModel.progressRatio)
                self.habitCalendarView.reloadItems(at: [indexPath])
            })
            .disposed(by: self.disposeBag)
    }
    
    private func presentPopupViewIfNeeded(with habitStatus: HabitResponseModel.HabitStatus?) {
        guard let status = habitStatus else { return }
        switch status {
            case .unseenSuccess:
                self.showSuccessPopupViewController()
            case .unseenFail:
                self.showFailPopupView(with: self.viewModel)
            case .run:
                guard self.viewModel.isDelayPenatyForLatestDailyHabits else { return }
                self.showDelayPopupView(with: self.viewModel)
            default:
                break
        }
    }
    
    private func bindButtons() {
        self.habitInfoView.settingButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            guard let self = self, let habitEditingViewController = HabitEditingViewController.instantiateViewController(from: .habitEdit)
            else { return }
            guard let habitInProgressModel = self.viewModel.habitResponseModel else { return }
            
            habitEditingViewController.delegate = self
            habitEditingViewController.viewModel = HabitEditViewModel(habitInProgressModel: habitInProgressModel)
            self.navigationController?.pushViewController(habitEditingViewController, animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private func showEmptyViewAndHideMainView() {
        self.barStyle = .darkContent
        self.setNeedsStatusBarAppearanceUpdate()
        self.updateEmptyViewHiddenStatus(false)
        self.updateContentViewHiddenStatus(true)
    }
    
    private func showMainViewAndHideEmptyView() {
        self.barStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        self.updateEmptyViewHiddenStatus(true)
        self.updateContentViewHiddenStatus(false)
    }
    
    private func updateEmptyViewHiddenStatus(_ isHidden: Bool) {
        self.homeEmptyView.isHidden = isHidden
    }
    
    private func updateContentViewHiddenStatus(_ isHidden: Bool) {
        let views = [self.habitInfoView, self.habitCalendarView]
        views.forEach { $0.isHidden = isHidden }
    }
    
    @objc private func updateUserInform(_ notification: Notification) {
        guard let currentUser = OnethingUserManager.sharedInstance.currentUser else { return }
        guard let nickname = currentUser.account?.nickname                     else { return }
        
        self.viewModel.update(nickname: nickname)
        self.habitInfoView.update(with: self.viewModel)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellDiameter = self.habitCalendarView.cellDiameter(superViewWidth: self.view.frame.width)
        return CGSize(width: cellDiameter, height: cellDiameter)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let responseModel = self.viewModel.dailyHabitResponseModel(at: indexPath.row) {
            let dailyHabitModel = DailyHabitModel(
                order: indexPath.row + 1,
                sentenceForDelay: viewModel.sentenceForDelay,
                responseModel: responseModel
            )
            
            self.presentHabitWrittenViewController(with: dailyHabitModel)
        } else {
            guard self.viewModel.canCreateCurrentDailyHabitModel(with: indexPath.row) else {
                self.showWriteLimitPopupView(with: indexPath)
                return
            }
            
            self.presentHabitWritingViewController(with: indexPath)
        }
    }
    
    private func showWriteLimitPopupView(with indexPath: IndexPath) {
        guard let writeLimitPopupView: CustomPopupView = UIView.createFromNib() else { return }
        guard let tabbarController = self.tabBarController                      else { return }
        
        writeLimitPopupView.configure(
            attributedText: self.viewModel.limitMessage(with: indexPath),
            numberText: self.viewModel.numberText(with: indexPath),
            image: HabitCalendarCell.placeholderImage
        )
        writeLimitPopupView.show(in: tabbarController)
    }
    
    private func showDelayPopupView(with viewModel: HomeViewModel) {
        guard let delayPopupView: DelayPopupView = UIView.createFromNib() else { return }
        guard let tabbarController = self.tabBarController                else { return }
        
        self.backgroundDimView.showCrossDissolve(completedAlpha: self.backgroundDimView.completedAlpha)
        
        delayPopupView.delegate = self
        delayPopupView.configure(with: viewModel)
        delayPopupView.show(in: tabbarController, completion: {
            delayPopupView.animateShaking()
        })
    }
    
    private func presentHabitWrittenViewController(with dailyHabitModel: DailyHabitModel) {
        self.backgroundDimView.showCrossDissolve(completedAlpha: self.backgroundDimView.completedAlpha)
        
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
            $0.viewModel = HabitWrittenViewModel(dailyHabitModel: dailyHabitModel)
            $0.delegate = self
        }
        self.present(habitWrittenViewController, animated: true)
    }
    
    private func presentHabitWritingViewController(with indexPath: IndexPath) {
        let habitWritingViewController = HabitWritingViewController().then {
            $0.delegate = self
            $0.viewModel = HabitWritingViewModel(
                habitId: self.viewModel.habitID ?? 1,
                dailyHabitOrder: indexPath.row + 1,
                session: Alamofire.AF
            )
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(habitWritingViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let habitCalendarView = collectionView as? HabitCalendarView else { return .zero }
        return UIEdgeInsets(
            top: habitCalendarView.topConstant,
            left: habitCalendarView.leadingConstant,
            bottom: habitCalendarView.bottomConstant,
            right: habitCalendarView.trailingConstant
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HeightRatioPresentationController(
            heightRatio: 0.6,
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

extension HomeViewController: HabitWrittenViewControllerDelegate {
    func habitWrittenViewControllerWillDismiss(_ habitWrittenViewController: HabitWrittenViewController) {
        self.backgroundDimView.hideCrossDissolve()
    }
}

extension HomeViewController: HabitWritingViewControllerDelegate {
    func update(currentDailyHabitModel: DailyHabitResponseModel) {
        self.viewModel.append(currentDailyHabitModel: currentDailyHabitModel)
        
        // 66일째 일일 습관 완료 후, 습관이 성공했을 때
        if self.viewModel.isHabitSuccess {
            self.viewModel.requestPassedHabitForSuccessOrFailView()
        }
    }
}

extension HomeViewController: HomeEmptyViewDelegate {
    func homeEmptyViewDidTapSelectButton(_ homeEmptyView: HomeEmptyView) {
        guard let goalSettingFirstViewController = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting),
              let navigationController = self.navigationController(goalSettingFirstViewController) else { return }
        
        self.present(navigationController, animated: true) {
            self.showMainViewAndHideEmptyView()
        }
    }
    
    private func navigationController(_ rootController: UIViewController?) -> UINavigationController? {
        guard let rootController = rootController else { return nil }
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}

extension HomeViewController: DelayPopupViewDelegate {
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView) {
        self.viewModel.update(isGiveUp: true)
        self.showFailPopupView(with: self.viewModel)
    }
    
    private func showFailPopupView(with viewModel: HomeViewModel) {
        guard let failPopupView: FailPopupView = UIView.createFromNib() else { return }
        guard let tabbarController = self.tabBarController              else { return }
        
        failPopupView.delegate = self
        failPopupView.configure(with: viewModel)
        failPopupView.show(in: tabbarController) {
            failPopupView.animateShaking()
        }
    }
    
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView) {
        self.backgroundDimView.isHidden = true
        self.delayPopupView = delayPopupView
        self.delayPopupView?.isHidden = true
        self.delayPopupView?.guideLabel.isHidden = true
        
        self.pushWritingPenaltyViewController()
    }
    
    private func pushWritingPenaltyViewController() {
        guard let writingPenaltyViewController = WritingPenaltyViewController.instantiateViewController(from: .writingPenalty),
              let habitId = self.viewModel.habitResponseModel?.habitId,
              let sentence = self.viewModel.habitResponseModel?.sentence,
              let penaltyCount = self.viewModel.habitResponseModel?.penaltyCount else { return }
        
        writingPenaltyViewController.delegate = self
        writingPenaltyViewController.viewModel = WritingPenaltyViewModel(
            habitID: habitId,
            sentence: sentence,
            penaltyCount: penaltyCount
        )
        self.navigationController?.pushViewController(writingPenaltyViewController, animated: true)
    }
}

extension HomeViewController: FailPopupViewDelegate {
    func failPopupViewDidTapCloseButton() {
        // uncheked fail인 경우
        if self.viewModel.hasToCheckUnseen == false {
            guard let habitID = self.viewModel.habitResponseModel?.habitId else { return }
            
            self.viewModel.requestUnseenFailToBeFail(habitId: habitID) { _ in
                self.viewModel.requestHabitInProgress()
                self.viewModel.update(isGiveUp: false)
                self.backgroundDimView.hideCrossDissolve()
            }
            return
        }
        
        // 습관 그만하기 버튼을 누른 경우
        self.viewModel.requestGiveup(completion: { [weak self] _ in
            self?.viewModel.requestHabitInProgress()
            self?.viewModel.update(isGiveUp: false)
            self?.backgroundDimView.hideCrossDissolve()
        })
    }
}

extension HomeViewController: WritingPenaltyViewControllerDelegate {
    func writingPenaltyViewControllerDidTapBackButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        self.backgroundDimView.isHidden = false
        self.delayPopupView?.isHidden = false
        self.delayPopupView?.guideLabel.isHidden = false
    }
    
    func writingPenaltyViewControllerDidTapCompleteButton(_ writingPenaltyViewController: WritingPenaltyViewController) {
        self.viewModel.requestHabitInProgress()
        self.delayPopupView?.hide()
    }
}

extension HomeViewController: HabitEditingViewControllerDelegate {
    func habitEditingViewControllerDidTapCompleteButton(_ habitEditingViewController: HabitEditingViewController) {
        guard let habitInProgressModel = habitEditingViewController.viewModel?.habitInProgressModel else { return }
        
        self.viewModel.update(habitInProgressModel: habitInProgressModel)
        self.habitInfoView.update(with: self.viewModel)
    }
}

extension HomeViewController: SuccessPopupViewControllerDelegate {
    func showSuccessPopupViewController() {
        let successPopupViewController = SuccessPopupViewController().then {
            $0.delegate = self
            $0.modalPresentationStyle = .fullScreen
        }
        
        guard let habitResponseModel = self.viewModel.habitResponseModel else { return }
        successPopupViewController.viewModel = SuccessPopupViewModel(habitResponseModel: habitResponseModel)
        self.present(successPopupViewController, animated: true)
    }
    
    func successPopupViewControllerDidTapButton(_ viewController: SuccessPopupViewController) {
        guard let status: HabitResponseModel.HabitStatus = self.viewModel.habitResponseModel?.onethingHabitStatus else { return }
        
        switch status {
            case .run:
                self.viewModel.requestHabitInProgress()
            case .unseenSuccess:
                self.viewModel.requestUnseenSuccessToBeSuccess { _ in
                    self.viewModel.requestHabitInProgress()
                }
            default:
                break
        }
    }
}
