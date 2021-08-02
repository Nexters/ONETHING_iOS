//
//  ViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    private let habitInfoView = HabitInfoView(frame: .zero, descriptionLabelTopConstant: 70)
    private var habitCalendarView = HabitCalendarView(
        frame: .zero, totalCellNumbers: 66, columnNumbers: 5
    )
    private let backgroundDimView = BackgroundDimView()
    private let homeEmptyView = HomeEmptyView().then {
        $0.isHidden = true
    }
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHabitInfoView()
        self.setupHabitCalendarView()
        self.setupBackgounndDimColorView()
        self.setupHomeEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.changeStatusBar(backgroundColor: self.habitInfoView.backgroundColor ?? .black_100)
        super.viewWillAppear(animated)
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
        guard let habitCalendarCell = collectionView.cellForItem(at: indexPath) as? HabitCalendarCell else { return }
        
        if habitCalendarCell.isWritten {
            self.presentHabitWrittenViewController(with: habitCalendarCell)
            return
        }
        self.presentHabitWritingViewController()
    }
    
    private func presentHabitWrittenViewController(with habitCalendarCell: HabitCalendarCell) {
        self.backgroundDimView.isHidden = false
        
        let habitWrittenViewController = HabitWrittenViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
            $0.update(upperStampImage: habitCalendarCell.stampImage)
            $0.delegate = self
        }
        self.present(habitWrittenViewController, animated: true)
    }
    
    private func presentHabitWritingViewController() {
        let habitWritingViewController = HabitWritingViewController()
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
