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
    
    private let apiService: APIService
    private(set) var habitInProgressModel: HabitResponseModel?
    private(set) var passedUncheckedModel: HabitResponseModel?
    private var dailyHabitModels = [DailyHabitResponseModel]()
    private var nickname: String?
    private let disposeBag = DisposeBag()
    private(set) var isGiveUp = false
    let habitInProgressSubject = PublishSubject<HabitResponseModel?>()
    let dailyHabitsSubject = PublishSubject<[DailyHabitResponseModel]>()
    let currentIndexPathOfDailyHabitSubject = PublishSubject<IndexPath>()
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.apiService.requestAndDecodeRx(
            apiTarget: ContentAPI.getHabitInProgress,
            retryHandler: { self.requestHabitInProgress() }
        ).subscribe(onSuccess: { [weak self] (responseModel: InProgressHabitResponseModel) in
            guard let habitInProgressModel = responseModel.data else {
                self?.habitInProgressSubject.onNext(nil)
                return
            }
            
            self?.habitInProgressModel = habitInProgressModel
            self?.habitInProgressSubject.onNext(habitInProgressModel)
        }).disposed(by: self.disposeBag)
    }
    
    func requestDailyHabits(habitId: Int) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getDailyHistories(habitId: habitId))
            .subscribe(onSuccess: { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
                self?.dailyHabitModels = dailyHabitsResponseModel.histories
                self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
            }).disposed(by: self.disposeBag)
    }
    
    func requestPassedHabitForSuccessOrFailView(completion: @escaping (HabitResponseModel.HabitStatus) -> Void) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getHabits)
            .subscribe(onSuccess: { (habitReseponseModels: [HabitResponseModel]) in
                guard let passedHabitModel = habitReseponseModels.last else { return }
                guard let habitStatus = passedHabitModel.castingHabitStatus else { return }
                
                self.passedUncheckedModel = passedHabitModel
                completion(habitStatus)
            }).disposed(by: self.disposeBag)
    }
    
    func requestUnseenFailToBeFail(habitId: Int, completion: @escaping (Bool) -> Void) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.putUnSeenFail(habitId: habitId))
            .subscribe(onSuccess: { (result: Bool) in
                
            completion(result)
        }).disposed(by: self.disposeBag)
    }
    
    func dailyHabitResponseModel(at index: Int) -> DailyHabitResponseModel? {
        return self.dailyHabitModels[safe: index]
    }
    
    var habitID: Int? {
        self.habitInProgressModel?.habitId
    }
    
    var isDelayPenatyForLatestDailyHabits: Bool {
        self.dailyHabitModels.last?.castingHabitStatus == .delayPenalty
    }
    
    var discriptionText: String? {
        guard let nickname = self.nickname else { return nil }
        
        return "\(nickname) 님의 66일 습관 목표"
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
    
    func update(habitInProgressModel: HabitResponseModel) {
        self.habitInProgressModel = habitInProgressModel
    }
    
    func update(nickname: String) {
        self.nickname = nickname
    }
    
    func clearModels() {
        self.dailyHabitModels.removeAll()
        self.habitInProgressModel = nil
    }
    
    func canCreateCurrentDailyHabitModel(with index: Int) -> Bool {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return false }
        return diffDays == index
    }
    
    func limitMessage(with indexPath: IndexPath) -> NSAttributedString? {
        let dayText = self.numberText(with: indexPath)
        let attributedText = NSMutableAttributedString(string: "\(dayText)일차에\n기록할 수 있어요!")
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.red_default,
                                    range: attributedText.mutableString.range(of: "\(dayText)일차"))
        return attributedText
    }
    
    var sentenceForDelay: String? {
        return self.habitInProgressModel?.sentence
    }
    
    var titleTextOfDelayPopupView: String? {
        return "앗!\n습관을 미뤘네요"
    }
    
    var remainedDelayTextOfDelayPopupView: String? {
        let delayMaxCount = self.habitInProgressModel?.delayMaxCount ?? 6
        let delayCount = self.habitInProgressModel?.delayCount ?? 0
        let remainedCount = delayMaxCount - delayCount
        return "남은 미루기 기회: \(remainedCount)번"
    }
    
    var titleTextOfFailPopupView: String? {
        return "아쉽지만\n습관은 여기까지!"
    }
    
    var progressCountTextOfFailPopupView: String? {
        return "진행: \(self.dailyHabitModels.count + 1)일차"
    }
    
    func update(isGiveUp: Bool) {
        self.isGiveUp = isGiveUp
    }
    
    var reasonTextOfFailPopupView: String? {
        self.isGiveUp ? "사유: 습관 그만하기" : "사유: 습관 미루기 7회 이상"
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
        self.makeCellHighlightedIfToday(with: indexPath, cell: habitCalendarCell)
        
        habitCalendarCell.setup(numberText: self.numberText(with: indexPath))
        return habitCalendarCell
    }
    
    private func makeCellHighlightedIfToday(with indexPath: IndexPath, cell habitCalendarCell: HabitCalendarCell) {
        guard self.canCreateCurrentDailyHabitModel(with: indexPath.row) else { return }
            
        habitCalendarCell.update(stampImage: UIImage(named: "stamp_today"))
        habitCalendarCell.update(textColor: UIColor.red_3)
    }
    
    func numberText(with indexPath: IndexPath) -> String {
        return "\(indexPath.item + 1)"
    }
}
