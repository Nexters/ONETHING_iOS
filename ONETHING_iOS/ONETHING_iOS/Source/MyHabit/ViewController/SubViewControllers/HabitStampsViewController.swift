//
//  HabitStampsViewController.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

import RxSwift

protocol HabitHistorySubViewControllerDelegate: AnyObject {
    func didTapDailyHabit(_ viewController: HabitHistorySubViewController, dailyHabitModel: DailyHabitModel)
}

final class HabitStampsViewController: UIViewController, HabitHistorySubViewController {
    weak var delegate: HabitHistorySubViewControllerDelegate?
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HabitStampsLayoutGuide.collectionViewFlowLayout)
    
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
        
        self.observeViewModel()
    }
    
    private func setupUI() {
        self.collectionView.do {
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.registerCell(cellType: HabitCalendarCell.self)
            $0.registerCell(cellType: UICollectionViewCell.self)
        }
        
        self.view.addSubview(self.collectionView)
    }
    
    private func setupLayout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindUI() {
        self.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let responseModel = owner.viewModel.dailyHabitsRelay.value[safe: indexPath.item],
                      let sentenceForDelay = owner.viewModel.presentable?.sentenceForDelay
                else {
                    return
                }
                
                let dailyHabitModel = DailyHabitModel(
                    order: indexPath.item + 1,
                    sentenceForDelay: sentenceForDelay,
                    responseModel: responseModel
                )
                owner.delegate?.didTapDailyHabit(owner, dailyHabitModel: dailyHabitModel)
            }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel
            .dailyHabitsRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.collectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}

extension HabitStampsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitHistoryViewModel.defaultTotalDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(cell: HabitCalendarCell.self, forIndexPath: indexPath)
        else { return self.defaultCell(collectionView: collectionView, indexPath: indexPath) }
        
        if let dailyHabitResponseModel = self.viewModel.dailyHabitResponseModel(at: indexPath.row) {
            habitCalendarCell.setup(with: dailyHabitResponseModel)
        } else {
            habitCalendarCell.setup(numberText: "\(indexPath.item + 1)")
        }
        
        if self.isLastCellAndSucceedStamp(indexPath: indexPath) {
            self.addSuccessSpeechView(to: habitCalendarCell)
        }
        
        return habitCalendarCell
    }
}

//MARK: - Related Last Cell
extension HabitStampsViewController {
    private func addSuccessSpeechView(to habitCalendarCell: HabitCalendarCell) {
        let sucessSpeechView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "success_speech_bubble")
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        habitCalendarCell.addSubview(sucessSpeechView)
        sucessSpeechView.snp.makeConstraints({ make in
            make.leading.equalTo(habitCalendarCell.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        })
    }
    
    private func isLastCellAndSucceedStamp(indexPath: IndexPath) -> Bool {
        guard self.isLastCell(with: indexPath) else {
            return false
        }
        
        guard self.isSuccessHabitStatus else {
            return false
        }
            
        guard self.isSucceedStampForLast else {
            return false
        }
            
        return true
    }
    
    private func isLastCell(with indexPath: IndexPath) -> Bool {
        let lastIndex = HabitHistoryViewModel.defaultTotalDays - 1
        return indexPath.row == lastIndex
    }
    
    private var isSuccessHabitStatus: Bool {
        guard let habitStatus = self.viewModel.habitInfoViewModel.presentable?.onethingHabitStatus
        else { return false }
        
        return habitStatus == .success
    }
    
    private var isSucceedStampForLast: Bool {
        let lastIndex = HabitHistoryViewModel.defaultTotalDays - 1
        guard let dailyHabitModelOfLast = self.viewModel.dailyHabitResponseModel(at: lastIndex)
        else { return false }
        
        let stampOfLast = dailyHabitModelOfLast.castingStamp
        return stampOfLast != .delay
    }
}
