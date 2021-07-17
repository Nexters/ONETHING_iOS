//
//  ViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    
    private let mainScrollView = UIScrollView()
    private let scrollInnerView = UIView()
    private let habitInfoView = HabitInfoView(frame: .zero, descriptionLabelTopConstant: 70)
    private var habitCalendarView = HabitCalendarView(
        frame: .zero, totalCellNumbers: 66, columnNumbers: 5
    )
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureHabitInfoView()
        configureMainScrollView()
        configureScrollInnerView()
        configureHabitCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeStatusBarColor()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        undoStatusBarColor()
        super.viewWillDisappear(animated)
    }
    
    private func changeStatusBarColor() {
        guard let statusBar = self.navigationController?.statusBar else { return }
        
        statusBar.previousBackgroundColor = statusBar.backgroundColor
        statusBar.backgroundColor = habitInfoView.backgroundColor
    }
    
    private func undoStatusBarColor() {
        guard let statusBar = self.navigationController?.statusBar else { return }
        
        statusBar.backgroundColor = statusBar.backgroundColor
    }
    
    private func configureHabitInfoView() {
        self.view.addSubview(self.habitInfoView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.habitInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.width.equalToSuperview()
            $0.height.equalTo(habitInfoView.snp.width).dividedBy(2)
        }
    }

    private func configureMainScrollView() {
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.habitInfoView.snp.bottom)
            $0.height.equalTo(self.view.frame.height - self.habitInfoView.frame.height)
        }
    }
    
    private func configureScrollInnerView() {
        self.mainScrollView.addSubview(self.scrollInnerView)
        
        self.scrollInnerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.mainScrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(self.scrollInnerView)
        }
    }
    
    private func configureHabitCalendarView() {
        self.habitCalendarView.backgroundColor = .clear
        self.habitCalendarView.dataSource = self.viewModel
        self.habitCalendarView.registerCell(cellType: HabitCalendarCell.self)
        self.habitCalendarView.delegate = self
        self.habitCalendarView.isScrollEnabled = false
        
        self.scrollInnerView.addSubview(habitCalendarView)
        self.habitCalendarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.scrollInnerView).inset(self.habitCalendarView.outerConstant)
            $0.top.equalTo(self.scrollInnerView).offset(self.habitCalendarView.topConstant)
            $0.height.equalTo(self.habitCalendarView.fixedHeight(superViewWidth: self.view.frame.width))
            $0.bottom.equalTo(self.scrollInnerView)
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
    
}
