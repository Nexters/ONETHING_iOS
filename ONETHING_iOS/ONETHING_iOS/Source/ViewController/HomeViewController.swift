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
    private let homeUpperView = HomeUpperView()
    private var habitCalendarView = HabitCalendarView(
        frame: .zero, totalCellNumbers: 66, columnNumbers: 6
    )
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainScrollView()
        configureScrollInnerView()
        configureHomeUpperView()
        configureHabitCalendarView()
    }

    private func configureMainScrollView() {
        self.view.addSubview(self.mainScrollView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.mainScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.width.equalToSuperview()
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
    
    private func configureHomeUpperView() {
        self.scrollInnerView.addSubview(self.homeUpperView)
        
        self.homeUpperView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.scrollInnerView).inset(34)
            $0.top.equalTo(self.scrollInnerView).inset(52)
            $0.height.equalTo(self.homeUpperView.snp.width).dividedBy(2.3)
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
            $0.leading.trailing.equalTo(self.homeUpperView)
            $0.top.equalTo(self.homeUpperView.snp.bottom).offset(20)
            $0.height.equalTo(self.habitCalendarView.snp.width).multipliedBy(self.habitCalendarView.ratioHeightPerWidth)
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
        
        let constant = (self.view.bounds.width - collectionView.frame.width) / 2
        let diameter = (collectionView.frame.width - 2 * constant) / CGFloat(self.habitCalendarView.numberOfColumns)
        
        return CGSize(width: diameter.rounded(.down), height: diameter)
    }
    
}
