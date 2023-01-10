//
//  HabitDocumentsViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

import RxSwift

final class HabitDocumentsViewController: UIViewController, HabitHistorySubViewController {
    weak var delegate: HabitHistorySubViewControllerDelegate?
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let emptyView = HistoryEmptyView(guideImage: UIImage(named: "notext_img")!, guideText: "기록한 이야기가 없어요")
    let viewModel: HabitHistoryViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HabitHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupLayout()
        
        self.viewModel.dailyHabitsRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let isEmpty = owner.viewModel.dailyHabitsThatHasDocuments.count == 0
                if isEmpty {
                    self.collectionView.isHidden = true
                    self.emptyView.isHidden = false
                    return
                }
                
                self.collectionView.isHidden = false
                self.emptyView.isHidden = true
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        self.collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.registerCell(cellType: DocumentCell.self)
            $0.registerCell(cellType: UICollectionViewCell.self)
        }
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.emptyView)
    }
    
    private func setupLayout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
        }
    }
}

extension HabitDocumentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dailyHabitsThatHasDocuments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let documentCell = collectionView.dequeueReusableCell(cell: DocumentCell.self, forIndexPath: indexPath)
        else { return self.defaultCell(collectionView: collectionView, indexPath: indexPath) }
        
        guard let responseModel = self.viewModel.dailyHabitsThatHasDocuments[safe: indexPath.row],
              let indexOfResponseModel = self.viewModel.dailyHabitsRelay.value.firstIndex(of: responseModel)
        else { return self.defaultCell(collectionView: collectionView, indexPath: indexPath) }
        
        documentCell.configure(
            order: indexOfResponseModel + 1,
            sentence: self.viewModel.presentable?.sentenceForDelay ?? "",
            viewModel: responseModel
        )
        
        return documentCell
    }
}

extension HabitDocumentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let fullWidth = self.collectionView.frame.width - 32 * 2
        let dummyCell = DocumentCell()
        
        guard let responseModel = self.viewModel.dailyHabitsThatHasDocuments[safe: indexPath.row],
              let indexOfResponseModel = self.viewModel.dailyHabitsRelay.value.firstIndex(of: responseModel)
        else { return .zero }
        
        
        dummyCell.configure(
            order: indexOfResponseModel + 1,
            sentence: self.viewModel.presentable?.sentenceForDelay ?? "",
            viewModel: responseModel
        )
        
        let size = dummyCell.contentView.systemLayoutSizeFitting(
            CGSize(width: fullWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 32, bottom: 24, right: 32)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    )-> CGFloat {
        return 20
    }
}
