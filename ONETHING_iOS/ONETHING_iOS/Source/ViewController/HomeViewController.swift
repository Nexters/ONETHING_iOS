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
    private let homeUpperView = HomeUpperView()
    private var habitCalendarView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainScrollView()
        configureHomeUpperView()
        configureHabitCalendarView()
    }

    private func configureMainScrollView() {
        self.view.addSubview(self.mainScrollView)
        
        mainScrollView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    private func configureHomeUpperView() {
        self.mainScrollView.addSubview(self.homeUpperView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        homeUpperView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(34)
            $0.top.equalTo(safeArea).inset(52)
            $0.height.equalTo(homeUpperView.snp.width).dividedBy(2.3)
        }
    }
    
    private func configureHabitCalendarView() {
        
        self.habitCalendarView.backgroundColor = .clear
        self.habitCalendarView.dataSource = viewModel
        self.habitCalendarView.register(HabitCalendarCell.self, forCellWithReuseIdentifier: HabitCalendarCell.reuseIdentifier)
        self.habitCalendarView.delegate = self
        
        self.mainScrollView.addSubview(habitCalendarView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.habitCalendarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(34)
            $0.top.equalTo(homeUpperView.snp.bottom).offset(20)
            $0.height.equalTo(800)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let constant = (self.view.bounds.width - collectionView.frame.width) / 2
        let diameter = (collectionView.frame.width - 2 * constant) / 4
        
        return CGSize(width: diameter.rounded(.down), height: diameter)
    }
}
