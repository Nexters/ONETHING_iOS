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
        self.bindButtons()
        self.observeGoalList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.directSetButtonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
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
    
    private func observeGoalList() {
        self.viewModel.reloadFlagSubejct.observeOnMain(onNext: { [weak self] in
            self?.collectionViews.forEach { $0.reloadData() }
        }).disposed(by: self.disposeBag)
    }
    
    private func bindButtons() {
        self.directSetButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.pushSecondGoalController()
        }).disposed(by: self.disposeBag)
    }
    
    private func pushSecondGoalController() {
        guard let viewController = GoalSettingSecondViewController
                .instantiateViewController(from: StoryboardName.goalSetting) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = GoalSettingFirstViewModel()

    @IBOutlet private var collectionViews: [UICollectionView]!
    @IBOutlet private weak var directSetButton: UIButton!
    @IBOutlet private weak var directSetButtonBottomConstraint: NSLayoutConstraint!
    
}

extension GoalSettingFirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var currentLine: Int = 0
        for index in self.collectionViews.indices {
            if self.collectionViews[safe: index] == collectionView { currentLine = index; break }
        }
        
        guard let goal = self.viewModel.goalSection[safe: currentLine]?[safe: indexPath.row % 4]                                          else { return UICollectionViewCell() }
        guard let goalSettingCell = collectionView.dequeueReusableCell(cell: GoalSettingCollectionViewCell.self, forIndexPath: indexPath) else { return UICollectionViewCell() }
        goalSettingCell.setup(goal)
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
        for index in self.collectionViews.indices {
            if self.collectionViews[safe: index] == collectionView { currentLine = index; break }
        }
        
        guard let goal = self.viewModel.goalSection[safe: currentLine]?[safe: indexPath.row % 4]                                          else { return .zero }
        let dummyLabel  = UILabel(frame: .zero)
        dummyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        dummyLabel.text = goal
        
        let edgeInset = UIEdgeInsets(top: 26, left: 41, bottom: 26, right: 41)
        let size      = dummyLabel.sizeThatFits(edgeInset)
        return CGSize(width: size.width, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
