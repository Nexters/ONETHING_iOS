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
    private var layout: LeftAlignedCollectionViewFlowLayout = {
        var layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 60, height: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    private var habitCalendarView: UICollectionView?
    
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
        habitCalendarView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let habitCalendarView = self.habitCalendarView else { return }
        
        self.mainScrollView.addSubview(habitCalendarView)
        let safeArea = self.view.safeAreaLayoutGuide
        habitCalendarView.backgroundColor = .red
        
        habitCalendarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(34)
            $0.top.equalTo(homeUpperView.snp.bottom).offset(20)
            $0.height.equalTo(self.view).multipliedBy(2)
        }
    }
}
