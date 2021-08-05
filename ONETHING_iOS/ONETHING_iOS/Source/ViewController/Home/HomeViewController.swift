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

final class HomeViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private let habitInfoView = HabitInfoView(frame: .zero, descriptionLabelTopConstant: 70)
    private var habitCalendarView = HabitCalendarView(
        frame: .zero, totalCellNumbers: HomeViewModel.defaultTotalDays, columnNumbers: 5
    )
    private let backgroundDimView = BackgroundDimView()
    private let homeEmptyView = HomeEmptyView().then {
        $0.isHidden = true
    }
    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHabitInfoView()
        self.setupHabitCalendarView()
        self.setupBackgounndDimColorView()
        self.setupHomeEmptyView()
        self.observeViewModel()
        
        self.viewModel.requestHabitInProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.changeStatusBar(backgroundColor: self.habitInfoView.backgroundColor ?? .black_100)
        super.viewWillAppear(animated)
    }
    
    override func reloadContentsIfRequired() {
        super.reloadContentsIfRequired()
    }
    
    private func setupHabitInfoView() {
        self.view.addSubview(self.habitInfoView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.habitInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.width.equalToSuperview()
            $0.height.equalTo(habitInfoView.snp.width).dividedBy(2)
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
        self.view.addSubview(self.backgroundDimView)
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupHomeEmptyView() {
        self.view.addSubview(self.homeEmptyView)
        self.homeEmptyView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func observeViewModel() {
        self.viewModel
            .habitInProgressSubject
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.requestDailyHabits(habitId: $0.habitId)
                self.habitInfoView.update(with: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        self.viewModel
            .dailyHabitsSubject
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.habitInfoView.progressView.update(ratio: self.viewModel.progressRatio ?? 0)
            }
            .disposed(by: disposeBag)
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
        if let dailyHabitModel = self.viewModel.dailyHabitModels[safe: indexPath.row] {
            self.presentHabitWrittenViewController(with: dailyHabitModel)
        } else {
            self.presentHabitWritingViewController(with: indexPath)
        }
    }
    
    private func presentHabitWrittenViewController(with dailyHabitModel: DailyHabitResponseModel) {
        self.backgroundDimView.isHidden = false
        
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
            $0.update(with: dailyHabitModel)
            $0.delegate = self
        }
        self.present(habitWrittenViewController, animated: true)
    }
    
    private func presentHabitWritingViewController(with indexPath: IndexPath) {
        let habitWritingViewController = HabitWritingViewController().then {
            $0.viewModel.habitId = self.viewModel.habitInProgressModel?.habitId
            $0.viewModel.dailyHabitOrder = indexPath.row + 1
        }
        
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
        self.backgroundDimView.isHidden = true
    }
}
