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
    
    let habitInfoView = HabitInfoView(frame: .zero, descriptionLabelTopConstant: 83)
    private let habitCollectionView = HabitCollectionView(
        frame: .zero,
        totalCellNumbers: HomeViewModel.defaultTotalDays,
        columnNumbers: 5
    )
    private let backgroundDimView = BackgroundDimView()
    private let homeEmptyView = HomeEmptyView().then { $0.isHidden = true }
    private let loadingIndicator = NNLoadingIndicator()
    weak var delayPopupView: DelayPopupView?
    
    let viewModel = HomeViewModel()
    var router: (NSObjectProtocol & HomeRoutingLogic)?
    private let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.router = HomeRouter().then {
            $0.viewController = self
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.router = HomeRouter().then {
            $0.viewController = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObserver()
        self.navigationController?.setupEnableSwipeBackMotion()
        self.setupUI()
        self.setupLayout()
        
        self.bindButtons()
        self.bindViewModel()
    
        self.viewModel.requestHabitInProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func reloadContentsIfRequired() {
        super.reloadContentsIfRequired()
        
        self.viewModel.requestHabitInProgress()
    }
    
    override func clearContents() {
        self.viewModel.clearModels()
    }
    
    // MARK: - Internal Methods
    
    func showDimView() {
        self.backgroundDimView.showCrossDissolve(completedAlpha: self.backgroundDimView.completedAlpha)
    }
    
    func hideDimView() {
        self.backgroundDimView.hideCrossDissolve()
    }
    
    func addDimTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.backgroundDimView.addTapGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeDimRecognizer() {
        self.backgroundDimView.removeTapGestureRecognizer()
    }
    
    // MARK: - Private Methods
    
    private func addObserver() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(self.updateUserInform(_:)),
            name: .didUpdateUserInform,
            object: nil
        )
    }
    
    private func setupUI() {
        self.habitCollectionView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self.viewModel
            $0.registerCell(cellType: HabitCalendarCell.self)
            $0.registerCell(cellType: UICollectionViewCell.self)
            $0.delegate = self
        }
        
        self.homeEmptyView.do {
            $0.delegate = self
        }
        
        self.view.addSubview(self.habitInfoView)
        self.view.addSubview(self.habitCollectionView)
        self.view.addSubview(self.backgroundDimView)
        self.view.addSubview(self.homeEmptyView)
        self.view.addSubview(self.loadingIndicator)
        
        self.updateContentViewHiddenStatus(true)
    }
    
    private func setupLayout() {
        self.habitInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(self.habitInfoView.snp.width).dividedBy(2)
        }
        
        self.habitCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.habitInfoView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        self.homeEmptyView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func bindButtons() {
        self.habitInfoView.settingButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            self?.router?.routeToHabitEditingViewController()
        }).disposed(by: self.disposeBag)
        
        self.habitCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.habitCalendarCellDidSelect(with: indexPath)
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // MARK: - Related to In Progress Habit
        self.viewModel
            .habitResponseModelSubject
            .bind { [weak self] habitInProgressModel in
                guard let self = self, let habitInProgressModel = habitInProgressModel
                else {
                    self?.handleIfIsUnSeenEvent()
                    return
                }
                
                self.revealMainViewAndHideEmptyView()
                self.viewModel.requestDailyHabits(habitId: habitInProgressModel.habitId)
                self.habitInfoView.update(with: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        self.viewModel
            .dailyHabitsSubject
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.habitInfoView.progressView.update(ratio: self.viewModel.progressRatio)
                self.habitCollectionView.reloadData()
                
                self.presentPopupViewIfNeeded(with: self.viewModel.habitInProgressModel?.onethingHabitStatus)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel
            .currentIndexPathOfDailyHabitSubject
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.habitInfoView.progressView.update(ratio: self.viewModel.progressRatio)
                self.habitCollectionView.reloadItems(at: [indexPath])
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.loadingSubject
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, loading in
                loading == true ? owner.loadingIndicator.startAnimating() : owner.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func handleIfIsUnSeenEvent() {
        let hasToCheckUnseen = self.viewModel.hasToCheckUnseen
        
        if hasToCheckUnseen {
            self.viewModel.requestPassedHabitForSuccessOrFailView()
        } else {
            self.revealEmptyViewAndHideMainView()
        }
    }
    
    private func presentPopupViewIfNeeded(with habitStatus: HabitStatus?) {
        guard let status = habitStatus else { return }
        switch status {
            case .unseenSuccess:
                self.router?.routeToSuccessPopupViewController()
            case .unseenFail:
                self.router?.showFailPopupView()
            case .run:
                guard self.viewModel.isDelayPenaltyForLastDailyHabit else { return }
                self.router?.showDelayPopupView()
            default:
                break
        }
    }
    
    private func habitCalendarCellDidSelect(with indexPath: IndexPath) {
        if let responseModel = self.viewModel.dailyHabitResponseModel(at: indexPath.row) {
            let dailyHabitModel = DailyHabitModel(
                order: indexPath.row + 1,
                sentenceForDelay: self.viewModel.sentenceForDelay,
                responseModel: responseModel
            )
            
            self.router?.routeToHabitWrittenViewController(with: dailyHabitModel)
        } else {
            guard self.viewModel.canCreateCurrentDailyHabitModel(with: indexPath.row) else {
                self.router?.showWriteLimitPopupView(with: indexPath)
                return
            }
            
            self.presentHabitWritingViewController(with: indexPath)
        }
    }
    
    private func revealEmptyViewAndHideMainView() {
        self.barStyle = .darkContent
        self.setNeedsStatusBarAppearanceUpdate()
        self.updateEmptyViewHiddenStatus(false)
        self.updateContentViewHiddenStatus(true)
    }
    
    func revealMainViewAndHideEmptyView() {
        self.barStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        self.updateEmptyViewHiddenStatus(true)
        self.updateContentViewHiddenStatus(false)
    }
    
    private func updateEmptyViewHiddenStatus(_ isHidden: Bool) {
        self.homeEmptyView.isHidden = isHidden
    }
    
    private func updateContentViewHiddenStatus(_ isHidden: Bool) {
        let views = [self.habitInfoView, self.habitCollectionView]
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
        let cellDiameter = self.habitCollectionView.cellDiameter(superViewWidth: self.view.frame.width)
        return CGSize(width: cellDiameter, height: cellDiameter)
    }
    
    private func presentHabitWritingViewController(with indexPath: IndexPath) {
        let writingViewModel = HabitWritingViewModel(
            habitId: self.viewModel.habitID ?? 1,
            dailyHabitOrder: indexPath.row + 1,
            session: Alamofire.AF
        )
        self.router?.routeToHabitWritingViewController(with: writingViewModel)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let habitCalendarView = collectionView as? HabitCollectionView else { return .zero }
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

extension HomeViewController: HomeEmptyViewDelegate {
    func homeEmptyViewDidTapSelectButton(_ homeEmptyView: HomeEmptyView) {
        self.router?.routeToGoalSettingFirstViewController()
    }
}
