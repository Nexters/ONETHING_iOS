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
    static let defaultTotalDays = 66
    
    private let apiService: APIService<ContentAPI>
    private var habitInProgressModel: HabitResponseModel?
    private var dailyHabitModels = [DailyHabitResponseModel]()
    let habitInProgressSubject = PublishSubject<HabitResponseModel>()
    let dailyHabitsSubject = PublishSubject<[DailyHabitResponseModel]>()
    let currentIndexPathOfDailyHabitSubject = PublishSubject<IndexPath>()
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.apiService.requestAndDecode(api: .getHabitInProgress) { [weak self] (habitResponseModel: HabitResponseModel) in
            self?.habitInProgressModel = habitResponseModel
            self?.habitInProgressSubject.onNext(habitResponseModel)
        }
    }
    
    func requestDailyHabits(habitId: Int) {
        self.apiService.requestAndDecode(api: .getDailyHistories(habitId: habitId)) { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
            self?.dailyHabitModels = dailyHabitsResponseModel.histories
            self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
        }
    }
    
    func dailyHabitModel(at index: Int) -> DailyHabitResponseModel? {
        return self.dailyHabitModels[safe: index]
    }
    
    var habitID: Int? {
        self.habitInProgressModel?.habitId
    }
    
    var discriptionText: String? {
        guard let habitId = self.habitInProgressModel?.habitId else { return nil }
        
        return "님의 \(habitId)번째 습관"
    }
    
    var textOfStartDate: String? {
        guard let habitInProgressModel = self.habitInProgressModel else { return nil }
        
        let date = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
        return date?.convertString(format: "yyyy.MM.dd")
    }
    
    var currentDayText: String? {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return nil }
        
        return String(diffDays + 1)
    }
    
    var textOfEndDate: String? {
        guard let habitInProgressModel = self.habitInProgressModel,
              let date = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
              else { return nil}
        
        let days = DateComponents(day: Self.defaultTotalDays - 1)
        let endDate = Calendar.current.date(byAdding: days, to: date)
        return endDate?.convertString(format: "yyyy.MM.dd")
    }
    
    var progressRatio: Double? {
        Double(dailyHabitModels.count) / Double(Self.defaultTotalDays)
    }
    
    var titleText: String? {
        self.habitInProgressModel?.title
    }
    
    private var diffDaysFromStartToCurrent: Int? {
        guard let habitInProgressModel = self.habitInProgressModel,
              let startDate = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd") else { return nil }
        
        let formatter = DateComponentsFormatter().then {
            $0.allowedUnits = [.day]
            $0.unitsStyle = .positional
        }
        
        guard let diffDaysStr = formatter
            .string(from: startDate, to: Date())?
            .components(separatedBy: .decimalDigits.inverted)
            .joined(), let diffDays = Int(diffDaysStr) else { return nil }
        
        return diffDays
    }
    
    func append(currentDailyHabitModel: DailyHabitResponseModel) {
        self.dailyHabitModels.append(currentDailyHabitModel)
        self.currentIndexPathOfDailyHabitSubject.onNext(IndexPath(item: self.dailyHabitModels.count - 1, section: 0))
    }
    
    func canCreatCurrentDailyHabitModel(with index: Int) -> Bool {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return false }
        return diffDays == index
    }
}

extension HomeViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let habitCalendarView = collectionView as? HabitCalendarView else { return Self.defaultTotalDays }
        return habitCalendarView.totalCellNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(cell: HabitCalendarCell.self, forIndexPath: indexPath)
        else { return self.defaultCell(collectionView: collectionView, indexPath: indexPath) }
        
        guard let dailyHabitModel = self.dailyHabitModels[safe: indexPath.row]
        else { return self.makeCellWithNumbers(with: indexPath, cell: habitCalendarCell) }
        
        let stamp = dailyHabitModel.castringStamp ?? Stamp.beige
        habitCalendarCell.set(isWrtten: true)
        habitCalendarCell.update(stampImage: stamp.defaultImage)
        habitCalendarCell.clearNumberText()
        
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
