//
//  GoalSettingFirstViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import RxSwift
import RxCocoa
import UIKit

final class GoalSettingFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
//        self.layoutCollectionView()
        self.observeGoalList()
    }
    
    private func setupCollectionView() {
        self.collectionViews.forEach { collectionView in
            collectionView.registerCell(cellType: GoalSettingCollectionViewCell.self)
        }
        
        self.collectionViews.forEach { collectionView in
            collectionView.dataSource = self
            collectionView.delegate   = self
        }
    }
    
//    private func layoutCollectionView() {
//        self.collectionViews.forEach { collectionView in
//            guard let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//            collectionViewLayout.estimatedItemSize       = UICollectionViewFlowLayout.automaticSize
//            collectionViewLayout.sectionInset            = .zero
//            collectionViewLayout.minimumLineSpacing      = 20
//            collectionViewLayout.minimumInteritemSpacing = 20
//        }
//    }
    
    private func observeGoalList() {
        self.viewModel.reloadFlagSubejct.observeOnMain(onNext: { [weak self] in
            self?.collectionViews.forEach { $0.reloadData() }
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = GoalSettingFirstViewModel()

    @IBOutlet private var collectionViews: [UICollectionView]!
    @IBOutlet private weak var directSetButton: UIButton!

}

extension GoalSettingFirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var currentLine: Int = 0
        self.collectionViews.enumerated().forEach { index, lineCollectionView in
            if lineCollectionView == collectionView { currentLine = index }
        }
        
        guard let goal = self.viewModel.goalSection[safe: currentLine]?[safe: indexPath.row % 4]                                          else { return UICollectionViewCell() }
        guard let goalSettingCell = collectionView.dequeueReusableCell(cell: GoalSettingCollectionViewCell.self, forIndexPath: indexPath) else { return UICollectionViewCell() }
        goalSettingCell.configure(goal)
        return goalSettingCell
    }
    
}

extension GoalSettingFirstViewController: UICollectionViewDelegate {
    
    
}

extension GoalSettingFirstViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var currentLine: Int = 0
        self.collectionViews.enumerated().forEach { index, lineCollectionView in
            if lineCollectionView == collectionView { currentLine = index }
        }
        guard let goal = self.viewModel.goalSection[safe: currentLine]?[safe: indexPath.row % 4]                                          else { return .zero }
        let dummyLabel  = UILabel(frame: .zero)
        dummyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        dummyLabel.text = goal
        
        let edgeInset = UIEdgeInsets(top: 26, left: 41, bottom: 26, right: 41)
        let size      = dummyLabel.getSize(edgeInset)
        return CGSize(width: size.width, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
