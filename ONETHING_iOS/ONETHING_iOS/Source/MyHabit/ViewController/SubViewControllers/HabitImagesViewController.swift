//
//  HabitImagesViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

import RxSwift

final class HabitImagesViewController: UIViewController, HabitHistorySubViewController {
    weak var delegate: HabitHistorySubViewControllerDelegate?
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HabitImagesLayoutGuide.collectionViewFlowLayout
    )
    private let emptyView = HistoryEmptyView(guideImage: UIImage(named: "noimage_img")!, guideText: "등록한 인증샷이 없어요")
    
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
        self.bindUI()
        
        self.viewModel.dailyHabitsRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let isEmpty = owner.viewModel.dailyHabitsThatHasImage.count == 0
                if isEmpty {
                    owner.collectionView.isHidden = true
                    owner.emptyView.isHidden = false
                    return
                }
                
                owner.collectionView.isHidden = false
                owner.emptyView.isHidden = true
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        self.collectionView.do {
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.registerCell(cellType: ImageCell.self)
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
    
    private func bindUI() {
        self.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let responseModel = owner.viewModel.dailyHabitsThatHasImage[safe: indexPath.item],
                      let indexOfResponseModel = owner.viewModel.dailyHabitsRelay.value.firstIndex(of: responseModel),
                      let sentenceForDelay = owner.viewModel.presentable?.sentenceForDelay
                else {
                    return
                }

                let dailyHabitModel = DailyHabitModel(
                    order: indexOfResponseModel + 1,
                    sentenceForDelay: sentenceForDelay,
                    responseModel: responseModel
                )
                owner.delegate?.didTapDailyHabit(owner, dailyHabitModel: dailyHabitModel)
            }).disposed(by: self.disposeBag)
    }
}

extension HabitImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dailyHabitsThatHasImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(cell: ImageCell.self, forIndexPath: indexPath)
        else {
            return self.defaultCell(collectionView: collectionView, indexPath: indexPath)
        }
        
        let dailyHabit = self.viewModel.dailyHabitsThatHasImage[safe: indexPath.item]
        guard let habitHistoryID = dailyHabit?.habitHistoryId,
              let createDate: String = dailyHabit?.createDateTime
                .convertToDate(format: DailyHabitResponseModel.dateFormat)?
                .convertString(format: "yyyy-MM-dd")
        else {
            return self.defaultCell(collectionView: collectionView, indexPath: indexPath)
        }
        
        HabitImageUseCase.shared.requestHabitImage(
            habitHistoryID: habitHistoryID,
            createDate: createDate,
            completionHandler: { image in
                imageCell.configure(with: image)
            }
        )
        
        return imageCell
    }
}
    
