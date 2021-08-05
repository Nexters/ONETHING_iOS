//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

import Moya
import RxSwift

final class HomeViewModel: NSObject {
    private let apiService: APIService<ContentAPI>
    private(set) var dailyHabitModels = [DailyHabitResponseModel]()
    let habitInProgressSubject = PublishSubject<HabitResponseModel>()
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.apiService.requestAndDecode(api: .getHabitInProgress) { [weak self] (habitResponseModel: HabitResponseModel) in
            self?.habitInProgressSubject.onNext(habitResponseModel)
        }
    }
    
    func requestDailyHabits(habitId: Int) {
        self.apiService.requestAndDecode(api: .getDailyHistories(habitId: habitId)) { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
            self?.dailyHabitModels = dailyHabitsResponseModel.histories
        }
    }
    
    
}

extension HomeViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let habitCalendarView = collectionView as? HabitCalendarView else { return HabitCalendarView.defaultTotalCellNumbers }
        return habitCalendarView.totalCellNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(cell: HabitCalendarCell.self, forIndexPath: indexPath)
        else { return HabitCalendarCell() }
        
        guard let dailyHabitModel = self.dailyHabitModels[safe: indexPath.row]
        else { return self.makeCellWithNumbers(with: indexPath, cell: habitCalendarCell) }
        
        let stamp = dailyHabitModel.castringStamp ?? Stamp.beige
        habitCalendarCell.set(isWrtten: true)
        habitCalendarCell.update(stampImage: stamp.defaultImage)
        habitCalendarCell.cleerNumberText()
        
        return habitCalendarCell
    }
    
    private func makeCellWithNumbers(with indexPath: IndexPath, cell habitCalendarCell: HabitCalendarCell) -> HabitCalendarCell {
        habitCalendarCell.setup(numberText: self.numberText(with: indexPath))
        return habitCalendarCell
    }
    
    private func numberText(with indexPath: IndexPath) -> String {
        return "\(indexPath.item + 1)"
    }
}
