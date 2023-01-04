//
//  HabitHistoryViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

import RxSwift
import RxCocoa

protocol HabitHistoryViewControllerDelegate: AnyObject {
    func habitHistoryViewControllerDidDeleteHabit(_ habitHistoryViewController: HabitHistoryViewController, deletedHabitID: Int)
}

final class HabitHistoryViewController: UIViewController, HabitWrittentVCParentable {
    let backgroundDimView = BackgroundDimView()
    private let myHabitInfoView = MyHabitInfoView()
    private let habitTabBar = HabitTabBar()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HabitHistoryLayoutGuide.collectionViewFlowLayout)
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    
    let viewModel: HabitHistoryViewModel
    private let disposeBag = DisposeBag()
    weak var delegate: HabitHistoryViewControllerDelegate?
    
    var viewsAreHidden: Bool = false {
        didSet {
            self.myHabitInfoView.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
            self.viewsAreHidden == true ? self.collectionView.isHidden = true : self.collectionView.showCrossDissolve()
            self.viewsAreHidden == true ? self.habitTabBar.isHidden = true : self.habitTabBar.showCrossDissolve()
        }
    }
    
    init(viewModel: HabitHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupLayout()
        self.myHabitInfoView.update(with: self.viewModel.habitInfoViewModel)
        self.bindUI()
        
        self.observeViewModel()
        self.viewModel.fetchDailyHabits()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.loadingIndicator.do {
            $0.stopAnimating()
        }
        
        self.myHabitInfoView.do {
            $0.delegate = self
        }
        
        self.collectionView.do {
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.registerCell(cellType: HabitCalendarCell.self)
            $0.registerCell(cellType: UICollectionViewCell.self)
        }
        
        self.habitTabBar.do {
            $0.delegate = self
        }
     
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.myHabitInfoView)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.habitTabBar)
        self.view.addSubview(self.backgroundDimView)
    }
    
    private func setupLayout() {
        self.loadingIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.myHabitInfoView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        
        self.collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.myHabitInfoView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        self.habitTabBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.myHabitInfoView.snp.bottom)
        }
        
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        self.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let responseModel = owner.viewModel.dailyHabitsRelay.value[safe: indexPath.item],
                      let sentenceForDelay = owner.viewModel.presentable?.sentenceForDelay
                else {
                    return
                }
                
                let dailyHabitModel = DailyHabitModel(
                    order: indexPath.item + 1,
                    sentenceForDelay: sentenceForDelay,
                    responseModel: responseModel
                )
                owner.routeToHabitWrittenViewController(with: dailyHabitModel)
            }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel
            .dailyHabitsRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.collectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func routeToHabitWrittenViewController(with dailyHabitModel: DailyHabitModel) {
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.viewModel = HabitWrittenViewModel(dailyHabitModel: dailyHabitModel)
        }
        
        let tapGestureForDimView = self.makeTapGestureRecognizerOfDimView(for: habitWrittenViewController)
        self.backgroundDimView.addTapGestureRecognizer(tapGestureForDimView)
        self.backgroundDimView.showCrossDissolve(completedAlpha: BackgroundDimView.completedAlpha)
        habitWrittenViewController.didMove(toViewController: self)
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
}

extension HabitHistoryViewController: HabitTabBarDelegate {
    func foo() {
        #warning("구현하자")
    }
}

extension HabitHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitHistoryViewModel.defaultTotalDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(cell: HabitCalendarCell.self, forIndexPath: indexPath)
        else { return self.defaultCell(collectionView: collectionView, indexPath: indexPath) }
        
        if let dailyHabitResponseModel = self.viewModel.dailyHabitResponseModel(at: indexPath.row) {
            habitCalendarCell.setup(with: dailyHabitResponseModel)
        } else {
            habitCalendarCell.setup(numberText: "\(indexPath.item + 1)")
        }
        
        if self.isLastCellAndSucceedStamp(indexPath: indexPath) {
            self.addSuccessSpeechView(to: habitCalendarCell)
        }
        
        return habitCalendarCell
    }
}

//MARK: - Related Last Cell
extension HabitHistoryViewController {
    private func addSuccessSpeechView(to habitCalendarCell: HabitCalendarCell) {
        let sucessSpeechView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "success_speech_bubble")
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        habitCalendarCell.addSubview(sucessSpeechView)
        sucessSpeechView.snp.makeConstraints({ make in
            make.leading.equalTo(habitCalendarCell.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        })
    }
    
    private func isLastCellAndSucceedStamp(indexPath: IndexPath) -> Bool {
        guard self.isLastCell(with: indexPath) else {
            return false
        }
        
        guard self.isSuccessHabitStatus else {
            return false
        }
            
        guard self.isSucceedStampForLast else {
            return false
        }
            
        return true
    }
    
    private func isLastCell(with indexPath: IndexPath) -> Bool {
        let lastIndex = HabitHistoryViewModel.defaultTotalDays - 1
        return indexPath.row == lastIndex
    }
    
    private var isSuccessHabitStatus: Bool {
        guard let habitStatus = self.viewModel.habitInfoViewModel.presentable?.onethingHabitStatus
        else { return false }
        
        return habitStatus == .success
    }
    
    private var isSucceedStampForLast: Bool {
        let lastIndex = HabitHistoryViewModel.defaultTotalDays - 1
        guard let dailyHabitModelOfLast = self.viewModel.dailyHabitResponseModel(at: lastIndex)
        else { return false }
        
        let stampOfLast = dailyHabitModelOfLast.castingStamp
        return stampOfLast != .delay
    }
}

extension HabitHistoryViewController: MyHabitInfoViewDelegate {
    func myHabitInfoView(_ view: MyHabitInfoView, didOccur event: MyHabitInfoView.ViewEvent) {
        switch event {
        case .backButton:
            self.dismiss(animated: true)
        case .share:
            self.presentHabitShareViewController(selectedHabit: self.viewModel.presentable)
        case .delete:
            self.showDeleteWarningPopupView()
        }
    }
    
    private func presentHabitShareViewController(selectedHabit: MyHabitCellPresentable?) {
        guard let selectedHabit = selectedHabit else { return }
        
        let habitShareViewController = MyHabitShareViewController()
        habitShareViewController.setShareHabit(selectedHabit)
        habitShareViewController.modalPresentationStyle = .fullScreen
        self.present(habitShareViewController, animated: true, completion: nil)
    }
    
    private func showDeleteWarningPopupView() {
        let popupView = self.deleteWarningPopupView
        popupView.show(in: self.view)
        self.view.bringSubviewToFront(self.loadingIndicator)
    }

    private var deleteWarningPopupView: TitleSubTitleConfirmPopupView {
        return TitleSubTitleConfirmPopupView().then { popupView in
            popupView.heightOfContentView = 160.0
            popupView.update(with: self.viewModel)
            popupView.confirmAction = { [weak self] _ in
                self?.viewModel.deleteHabit()
            }
            popupView.cancelAction = { popupView in
                popupView.removeFromSuperview()
            }
            self.observeViewModel(with: popupView)
        }
    }
    
    private func observeViewModel(with deleteWarningPopupView: TitleSubTitleConfirmPopupView) {
        self.viewModel.loadingSubject
            .subscribe(onNext: { [weak self, weak deleteWarningPopupView] loading in
                deleteWarningPopupView?.buttons.forEach {
                    $0.isUserInteractionEnabled = loading == false
                }
                loading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let deletedHabitID = self.viewModel.presentable?.habitId else { return }
                
                self.transitioningDelegate = nil
                self.delegate?.habitHistoryViewControllerDidDeleteHabit(self, deletedHabitID: deletedHabitID)
                self.dismiss(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
