//
//  MyHabitViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/20.
//

import UIKit
import Then
import SnapKit
import RxCocoa
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
        self.observeViewModel()
        self.viewModel.occur(viewEvent: .viewDidLoad)
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
            $0.currentPageIndicatorTintColor = .red_3
            $0.pageIndicatorTintColor = .black_20
        }
        
        self.emptyView.do {
            $0.isHidden = true
        }
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.habitNumberLabel)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.loadingIndicator)
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
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func observeViewModel() {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.viewModel.habitCountObservable
            .withUnretained(self)
            .observeOnMain(onNext: { owner, count in
                let isEmptyHabit = count == 0
                
                owner.pageControl.isHidden = isEmptyHabit
                owner.collectionView.isHidden = isEmptyHabit
                owner.habitNumberLabel.isHidden = isEmptyHabit
                owner.emptyView.isHidden = isEmptyHabit == false
                
                owner.pageControl.numberOfPages = count
                owner.habitNumberLabel.text = "\(count)개"
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.currentPageObservable
            .bind(to: self.pageControl.rx.currentPage)
            .disposed(by: self.disposeBag)
        
        self.viewModel.habitListObservable
            .bind(to: self.collectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cellType = MyHabitCollectionViewCell.self
                let cell = collectionView.dequeueReusableCell(cell: cellType, forIndexPath: indexPath)
                
                guard let myHabitCell = cell else { return UICollectionViewCell() }
                myHabitCell.delegate = self
                myHabitCell.configure(presentable: item, index: index)
                return myHabitCell
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.loadingSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, loading in
                loading == true ? owner.loadingIndicator.startAnimating() : owner.loadingIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
    }
    
    private let titleLabel = UILabel(frame: .zero)
    private let habitNumberLabel = UILabel(frame: .zero)
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: MyHabitLayoutGuide.collectionViewFlowLayout
    )
    private let pageControl = UIPageControl()
    private let emptyView = MyHabitEmptyView(frame: .zero)
    private let loadingIndicator = NNLoadingIndicator()
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyHabitViewModel
    
}

extension MyHabitViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffsetX = targetContentOffset.pointee.x
        let width = MyHabitLayoutGuide.collectionViewItemSize.width + MyHabitLayoutGuide.collectionViewMinimumLineSpacing
        
        let estimatedPage = round(targetOffsetX / width)
        let castingIntPage = Int(estimatedPage)
        
        let estimatedOffsetX = width * CGFloat(castingIntPage)
        targetContentOffset.pointee = CGPoint(x: estimatedOffsetX, y: 0)
        self.viewModel.occur(viewEvent: .scroll(page: castingIntPage))
    }
    
}

extension MyHabitViewController: MyHabitCollectionViewCellDelegate {
    
    func myhabitCollectionViewCell(_ cell: MyHabitCollectionViewCell, didTapShare habit: MyHabitCellPresentable) {
        self.presentHabitShareViewController(selectedHabit: habit)
    }
    
    private func presentHabitShareViewController(selectedHabit: MyHabitCellPresentable) {
        let habitShareViewController = MyHabitShareViewController()
        habitShareViewController.setShareHabit(selectedHabit)
        habitShareViewController.modalPresentationStyle = .fullScreen
        self.present(habitShareViewController, animated: true, completion: nil)
    }

}
