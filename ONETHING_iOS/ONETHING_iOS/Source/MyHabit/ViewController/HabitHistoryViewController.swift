//
//  HabitHistoryViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

import RxSwift

protocol HabitHistoryViewControllerDelegate: AnyObject {
    func habitHistoryViewControllerDidDeleteHabit(_ habitHistoryViewController: HabitHistoryViewController, deletedHabitID: Int)
}

final class HabitHistoryViewController: UIViewController {
    private let myHabitInfoView = MyHabitInfoView()
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
            self.collectionView.isHidden = self.viewsAreHidden
            self.view.backgroundColor = self.viewsAreHidden ? .clear : .white
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
        
        self.observeViewModel()
        self.viewModel.fetchDailyHabits()
    }
    
    private func setupUI() {
        self.loadingIndicator.do {
            $0.stopAnimating()
        }
        
        self.myHabitInfoView.do {
            $0.delegate = self
        }
        
        self.collectionView.do {
            $0.backgroundColor = .clear
            $0.registerCell(cellType: HabitCalendarCell.self)
            $0.registerCell(cellType: UICollectionViewCell.self)
        }
     
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.myHabitInfoView)
        self.view.addSubview(self.collectionView)
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
    }
    
    private func observeViewModel() {
        self.viewModel.dailyHabitsObservable
            .bind(to: self.collectionView.rx.items) { collectionView, index, dailyHabitModel in
                let indexPath = IndexPath(row: index, section: 0)
                let cellType = HabitCalendarCell.self
                let cell = collectionView.dequeueReusableCell(cell: cellType, forIndexPath: indexPath)
                
                guard let habitCalendarCell = cell else { return UICollectionViewCell() }
                
                let stamp = dailyHabitModel.castingStamp ?? .beige
                habitCalendarCell.update(stampImage: stamp.defaultImage)
                
                return habitCalendarCell
            }
            .disposed(by: self.disposeBag)
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

