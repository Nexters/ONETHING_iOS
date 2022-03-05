//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

import Moya
import RxSwift

final class HomeViewModel: NSObject, GiveUpWarningPopupViewPresentable, FailPopupViewPresentable {
    static let defaultTotalDays = 66
    
    private let apiService: APIServiceType
    private(set) var habitResponseModel: HabitResponseModel?
    private var dailyHabitModels = [DailyHabitResponseModel]()
    private(set) var hasToCheckUnseen = true
    let habitResponseModelSubject = PublishSubject<HabitResponseModel?>()
    let dailyHabitsSubject = PublishSubject<[DailyHabitResponseModel]>()
    
    private var nickname: String?
    private let disposeBag = DisposeBag()
    private(set) var isGiveUp = false
    let currentIndexPathOfDailyHabitSubject = PublishSubject<IndexPath>()
    
    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.apiService.requestAndDecodeRx(
            apiTarget: ContentAPI.getHabitInProgress,
            retryHandler: { self.requestHabitInProgress() }
        ).subscribe(onSuccess: { [weak self] (wrappingResponseModel: WrappingHabitResponseModel) in
            guard let habitInProgressModel = wrappingResponseModel.data else {
                self?.habitResponseModelSubject.onNext(nil)
                return
            }
            
            self?.habitResponseModel = habitInProgressModel
            self?.habitResponseModelSubject.onNext(habitInProgressModel)
        }).disposed(by: self.disposeBag)
    }
    
    func requestDailyHabits(habitId: Int) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getDailyHistories(habitId: habitId), retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
                self?.dailyHabitModels = dailyHabitsResponseModel.histories
                self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
            }).disposed(by: self.disposeBag)
    }
    
    func requestPassedHabitForSuccessOrFailView() {
        guard self.hasToCheckUnseen == true else { return }
        
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getUnseenStatus, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (wrappingResponseModel: WrappingHabitResponseModel) in
                self?.hasToCheckUnseen = false
                
                guard let unseenHabitModel = wrappingResponseModel.data else {
                    self?.habitResponseModelSubject.onNext(nil)
                    return
                }
                
                self?.habitResponseModel = unseenHabitModel
                self?.habitResponseModelSubject.onNext(unseenHabitModel)
            }).disposed(by: self.disposeBag)
    }
    
    func requestUnseenDailyHabits(habitId: Int) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getDailyHistories(habitId: habitId),
                                           retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
                self?.dailyHabitModels = dailyHabitsResponseModel.histories
                self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
            }).disposed(by: self.disposeBag)
    }
    
    func requestGiveup(completion: @escaping (HabitResponseModel) -> Void) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.putGiveUpHabit, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (habitResponseModel: HabitResponseModel) in
                self?.hasToCheckUnseen = false
                
                completion(habitResponseModel)
            }).disposed(by: self.disposeBag)
    }
    
    func requestUnseenFailToBeFail(habitId: Int, completion: @escaping (Bool) -> Void) {
        let putUnseenFail = ContentAPI.putUnSeenFail(habitId: habitId)
        
        self.apiService.requestRx(apiTarget: putUnseenFail, retryHandler: nil)
            .subscribe(onSuccess: { response in
                let isSuccess = response.statusCode == 200
                completion(isSuccess)
            })
            .disposed(by: self.disposeBag)
    }
    
    func requestUnseenSuccessToBeSuccess(completion: @escaping (Bool) -> Void) {
        guard let habitID = self.habitResponseModel?.habitId else { completion(false); return }
        
        let putUnseenSuccess = ContentAPI.putUnSeenSuccess(habitId: habitID)
        self.apiService.requestRx(apiTarget: putUnseenSuccess, retryHandler: nil)
            .subscribe(onSuccess: { response in
                let isSuccess = response.statusCode == 200
                completion(isSuccess)
            })
            .disposed(by: self.disposeBag)
    }
    
    func dailyHabitResponseModel(at index: Int) -> DailyHabitResponseModel? {
        return self.dailyHabitModels[safe: index]
    }
    
    var habitID: Int? {
        self.habitResponseModel?.habitId
    }
    
    var isDelayPenatyForLatestDailyHabits: Bool {
        self.dailyHabitModels.last?.castingHabitStatus == .delayPenalty
    }
    
    var discriptionText: String? {
        guard let nickname = self.nickname else { return nil }
        
        return "\(nickname) 님의 66일 습관 목표"
    }
    
    var textOfStartDate: String? {
        guard let habitInProgressModel = self.habitResponseModel else { return nil }
        
        let date = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
        return date?.convertString(format: "yyyy.MM.dd")
    }
    
    var currentDayText: String? {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return nil }
        
        return String(diffDays + 1)
    }
    
    var textOfEndDate: String? {
        guard let habitInProgressModel = self.habitResponseModel,
              let date = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
        else { return nil}
        
        let days = DateComponents(day: Self.defaultTotalDays - 1)
        let endDate = Calendar.current.date(byAdding: days, to: date)
        return endDate?.convertString(format: "yyyy.MM.dd")
    }
    
    var progressRatio: Double {
        return Double(self.dailyHabitModels.count) / Double(Self.defaultTotalDays)
    }
    
    var titleText: String? {
        self.habitResponseModel?.title
    }
    
    private var diffDaysFromStartToCurrent: Int? {
        guard let habitInProgressModel = self.habitResponseModel,
              let startDate = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
        else { return nil }
        
        let formatter = DateComponentsFormatter().then {
            $0.allowedUnits = [.day]
            $0.unitsStyle = .positional
        }
        
        guard let diffDaysStr = formatter
                .string(from: startDate, to: Date())?
                .components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined(), let diffDays = Int(diffDaysStr) else { return nil }
        
        return diffDays
    }
    
    func append(currentDailyHabitModel: DailyHabitResponseModel) {
        self.dailyHabitModels.append(currentDailyHabitModel)
        self.currentIndexPathOfDailyHabitSubject.onNext(IndexPath(item: self.dailyHabitModels.count - 1, section: 0))
    }
    
    func update(habitInProgressModel: HabitResponseModel) {
        self.habitResponseModel = habitInProgressModel
    }
    
    func update(nickname: String) {
        self.nickname = nickname
    }
    
    func clearModels() {
        self.dailyHabitModels.removeAll()
        self.habitResponseModel = nil
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
        return self.habitResponseModel?.sentence
    }
    
    var titleTextOfDelayPopupView: String? {
        return "앗!\n습관을 미뤘네요"
    }
    
    var remainedDelayTextOfDelayPopupView: String? {
        let delayMaxCount = self.habitResponseModel?.delayMaxCount ?? 6
        let delayCount = self.habitResponseModel?.delayCount ?? 0
        let remainedCount = delayMaxCount - delayCount
        return "남은 미루기 기회: \(remainedCount)번"
    }
    
    var titleTextOfFailPopupView: String? {
        return "아쉽지만\n습관은 여기까지!"
    }
    
    var subTitleTextOfGiveupWarningPopupView: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 15)
        else { return nil }
        
        let titleText = "열심히 달려온\n지금의 습관을\n정말로 그만하시겠어요?"
        let attributeText = NSMutableAttributedString(string: titleText,
                                                      attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100])
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineSpacing = 4.0
            $0.alignment = .center
        }
        attributeText.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributeText.length)
        )
        return attributeText
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
    
    var isHabitSuccess: Bool {
        self.dailyHabitModels.count == Self.defaultTotalDays
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
