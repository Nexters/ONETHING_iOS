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
        self.layoutCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionViews.forEach { $0.registerCell(cellType: GoalSettingCollectionViewCell.self) }
        
        self.viewModel.displayListSubjects.enumerated().forEach { index, subject in
            guard let collectionView = self.collectionViews[safe: index] else { return }
            self.bindCollectionView(collectionView, subject)
        }
    }
    
    private func bindCollectionView(_ collectionView: UICollectionView, _ subject: BehaviorSubject<[String]>) {
        subject.bind(to: collectionView.rx.items) { collectionView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            guard let goalSettingCell = collectionView.dequeueReusableCell(cell: GoalSettingCollectionViewCell.self,
                                                                           forIndexPath: indexPath) else {
                return UICollectionViewCell()
            }
            
            goalSettingCell.configure(item)
            
            let randomRed   = Int((0...255).randomElement() ?? 0)
            let randomGreen = Int((0...255).randomElement() ?? 0)
            let randomBlue  = Int((0...255).randomElement() ?? 0)
            goalSettingCell.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue)
            return goalSettingCell
        }.disposed(by: self.disposeBag)
    }
    
    private func layoutCollectionView() {
        self.collectionViews.forEach { collectionView in
            guard let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            collectionViewLayout.estimatedItemSize       = UICollectionViewFlowLayout.automaticSize
            collectionViewLayout.sectionInset            = .zero
            collectionViewLayout.minimumLineSpacing      = 20
            collectionViewLayout.minimumInteritemSpacing = 20
        }
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel  = GoalSettingFirstViewModel()

    @IBOutlet private var collectionViews: [UICollectionView]!
    @IBOutlet private weak var directSetButton: UIButton!

}
