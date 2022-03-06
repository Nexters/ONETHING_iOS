//
//  MyHabitViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/20.
//

import SnapKit
import UIKit
import RxSwift

final class MyHabitViewController: BaseViewController {
    
    init(viewModel: MyHabitViewModel = MyHabitViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.layoutUI()
    }
    
    private func setupUI() {
        self.titleLabel.do {
            $0.text = "내 습관"
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
        }
        
        self.habitNumberLabel.do {
            $0.text = "\(0)개"
            $0.textColor = .black_40
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 18)
        }
        
        self.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.allowsSelection = false
            $0.isPagingEnabled = false
            $0.clipsToBounds = false
            $0.decelerationRate = .fast
            $0.registerCell(cellType: MyHabitCollectionViewCell.self)
        }
        
        self.pageControl.do {
            // TODO: - 습관 개수에 따라 수정 필요
            $0.numberOfPages = 5
            $0.currentPage = 0
            $0.currentPageIndicatorTintColor = .red_3
            $0.pageIndicatorTintColor = .black_20
        }
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.habitNumberLabel)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.pageControl)
    }
    
    private func layoutUI() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(54)
            make.leading.equalToSuperview().offset(32)
        }
        
        self.habitNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(MyHabitLayoutGuide.collectionViewItemSize.height)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private let titleLabel: UILabel = UILabel(frame: .zero)
    private let habitNumberLabel: UILabel = UILabel(frame: .zero)
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: MyHabitLayoutGuide.collectionViewFlowLayout
    )
    private let pageControl = UIPageControl()
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyHabitViewModel
    
}

extension MyHabitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - 습관 개수에 따라 수정 필요
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: MyHabitCollectionViewCell.self, forIndexPath: indexPath)
        
        guard let myHabitCell = cell else { return UICollectionViewCell() }
        myHabitCell.delegate = self
        myHabitCell.configure(habitState: indexPath.row % 2 == 0 ? .success : .failure)
        return myHabitCell
    }
    
}

extension MyHabitViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffsetX = targetContentOffset.pointee.x
        let width = MyHabitLayoutGuide.collectionViewItemSize.width + MyHabitLayoutGuide.collectionViewMinimumLineSpacing
        
        let estimatedPage = round(targetOffsetX / width)
        let castingIntPage = Int(estimatedPage)
        
        let estimatedOffsetX = width * CGFloat(castingIntPage)
        targetContentOffset.pointee = CGPoint(x: estimatedOffsetX, y: 0)
    }
    
}

extension MyHabitViewController: MyHabitCollectionViewCellDelegate {
    
    func myhabitCollectionViewCell(_ cell: MyHabitCollectionViewCell, didTapShare habit: String) {
        self.presentHabitShareViewController(selectedHabit: habit)
    }
    
    private func presentHabitShareViewController(selectedHabit: String) {
        // TODO: - 선택된 Habit 정보 넘겨줘야함
        let habitShareViewController = MyHabitShareViewController()
        habitShareViewController.modalPresentationStyle = .fullScreen
        self.present(habitShareViewController, animated: true, completion: nil)
    }

}
