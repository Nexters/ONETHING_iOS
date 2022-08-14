//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

import Moya
import RxSwift

final class HomeViewModel: NSObject, GiveUpWarningPopupViewPresentable {
    static let defaultTotalDays = 66
    
    private let apiService: APIServiceType
    private(set) var habitInProgressModel: HabitResponseModel?
    private var dailyHabitModels = [DailyHabitResponseModel]()
    private(set) var hasToCheckUnseen = true
    
    private var nickname: String?
    private let disposeBag = DisposeBag()
    private(set) var isGiveUp = false
    
    // MARK: - Subjects
    let habitResponseModelSubject = PublishSubject<HabitResponseModel?>()
    let dailyHabitsSubject = PublishSubject<[DailyHabitResponseModel]>()
    let currentIndexPathOfDailyHabitSubject = PublishSubject<IndexPath>()
    let loadingSubject = BehaviorSubject<Bool>(value: false)
    
    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.loadingSubject.onNext(true)
        
        self.apiService.requestAndDecodeRx(
            apiTarget: ContentAPI.getHabitInProgress,
            retryHandler: { self.requestHabitInProgress() }
        ).subscribe(onSuccess: { [weak self] (wrappingResponseModel: WrappingHabitResponseModel) in
            guard let habitInProgressModel = wrappingResponseModel.data else {
                self?.habitResponseModelSubject.onNext(nil)
                return
            }
            
            self?.habitInProgressModel = habitInProgressModel
            self?.habitResponseModelSubject.onNext(habitInProgressModel)
        }).disposed(by: self.disposeBag)
    }
    
    func requestDailyHabits(habitId: Int) {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getDailyHistories(habitId: habitId), retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
                defer { self?.loadingSubject.onNext(false) }
                
                self?.dailyHabitModels = dailyHabitsResponseModel.histories
                self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
            }).disposed(by: self.disposeBag)
    }
    
    func requestPassedHabitForSuccessOrFailView() {
        guard self.hasToCheckUnseen == true else { return }
        
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getUnseenStatus, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (wrappingResponseModel: WrappingHabitResponseModel) in
                defer { self?.loadingSubject.onNext(false) }
                
                self?.hasToCheckUnseen = false
                
                guard let unseenHabitModel = wrappingResponseModel.data else {
                    self?.habitResponseModelSubject.onNext(nil)
                    return
                }
                
                self?.habitInProgressModel = unseenHabitModel
                self?.habitResponseModelSubject.onNext(unseenHabitModel)
            }).disposed(by: self.disposeBag)
    }
    
    func requestUnseenDailyHabits(habitId: Int) {
        self.apiService
            .requestAndDecodeRx(
                apiTarget: ContentAPI.getDailyHistories(habitId: habitId),
                retryHandler: nil
            )
            .subscribe(onSuccess: { [weak self] (dailyHabitsResponseModel: DailyHabitsResponseModel) in
                defer { self?.loadingSubject.onNext(false) }
                
                self?.dailyHabitModels = dailyHabitsResponseModel.histories
                self?.dailyHabitsSubject.onNext(dailyHabitsResponseModel.histories)
            }).disposed(by: self.disposeBag)
    }
    
    func requestGiveup(completion: @escaping (HabitResponseModel) -> Void) {
        self.apiService
            .requestAndDecodeRx(apiTarget: ContentAPI.putGiveUpHabit, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] (habitResponseModel: HabitResponseModel) in
                defer { self?.loadingSubject.onNext(false) }
                
                self?.hasToCheckUnseen = false
                
                completion(habitResponseModel)
            }).disposed(by: self.disposeBag)
    }
    
    func requestUnseenFailToBeFail(habitId: Int, completion: @escaping (Bool) -> Void) {
        let putUnseenFail = ContentAPI.putUnSeenFail(habitId: habitId)
        
        self.apiService
            .requestRx(apiTarget: putUnseenFail, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] response in
                defer { self?.loadingSubject.onNext(false) }
                
                let isSuccess = response.statusCode == 200
                completion(isSuccess)
            })
            .disposed(by: self.disposeBag)
    }
    
    func requestUnseenSuccessToBeSuccess(completion: @escaping (Bool) -> Void) {
        guard let habitID = self.habitInProgressModel?.habitId else { completion(false); return }
        
        let putUnseenSuccess = ContentAPI.putUnSeenSuccess(habitId: habitID)
        self.apiService
            .requestRx(apiTarget: putUnseenSuccess, retryHandler: nil)
            .subscribe(onSuccess: { [weak self] response in
                defer { self?.loadingSubject.onNext(false) }
                
                let isSuccess = response.statusCode == 200
                completion(isSuccess)
            })
            .disposed(by: self.disposeBag)
    }
    
    func dailyHabitResponseModel(at index: Int) -> DailyHabitResponseModel? {
        return self.dailyHabitModels[safe: index]
    }
    
    var habitID: Int? {
        self.habitInProgressModel?.habitId
    }
    
    var isDelayPenaltyForLastDailyHabit: Bool {
        self.dailyHabitModels.last?.isDelayPenaltyHabit == true
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
    
    var textOfEndDate: String? {
        guard let habitInProgressModel = self.habitInProgressModel,
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
        self.habitInProgressModel?.title
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
    
    var titleTextOfDelayPopupView: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .bold),
            size: 26.0)
        else { return nil }
        
        guard let penaltyDaysText = self.delayPenaltyDaysText
        else { return nil }
        
        let titleText = "앗!\n\(penaltyDaysText)\n습관을 미뤘네요"
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        attributeText.addAttribute(
            .foregroundColor,
            value: UIColor.red_default,
            range: (titleText as NSString).range(of: penaltyDaysText)
        )
        return attributeText.with(lineSpacing: 8.0)
    }
    
    private var delayPenaltyDaysText: String? {
        guard self.isDelayPenaltyForLastDailyHabit else { return nil }
        
        var delayPenaltyDays: [String] = []
        for index in (0 ..< self.dailyHabitModels.count).reversed() {
            guard self.dailyHabitModels[safe: index]?.isDelayPenaltyHabit == true
            else { break }
            
            // index가 3이라면 4일차, 마지막 index가 0이라면 1일차로 표현됩니다.
            delayPenaltyDays.insert("\(index + 1)", at: 0)
        }
        
        // NOTE
        // delayPenalty인 일일습관이 1 ~ 5 개 있는 경우 => 1줄
        // delayPenalty인 일일습관이 6 개 있는 경우 => 2줄
        switch delayPenaltyDays.count {
        case 1:
            return "\(delayPenaltyDays.first!)일차"
        case 2 ... 5:
            return delayPenaltyDays.reduce("") { result, element -> String in
                if delayPenaltyDays.first == element { return "\(element)" }
                else if delayPenaltyDays.last == element { return "\(result), \(element)일차" }
                else { return "\(result), \(element)" }
            }
        case 6:
            return delayPenaltyDays.reduce("") { result, element -> String in
                if delayPenaltyDays.first == element { return "\(element)" }
                else if delayPenaltyDays.last == element { return "\(result),\n\(element)일차" }
                else { return "\(result), \(element)" }
            }
        default:
            return nil
        }
    }
    
    var remainedDelayTextOfDelayPopupView: String? {
        let delayMaxCount = self.habitInProgressModel?.delayMaxCount ?? 6
        let delayCount = self.habitInProgressModel?.delayCount ?? 0
        let remainedCount = delayMaxCount - delayCount
        return "남은 미루기 기회: \(remainedCount)번"
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
        
        let stamp = dailyHabitModel.castingStamp ?? Stamp.beige
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

extension HomeViewModel: FailPopupViewPresentable {
    func update(isGiveUp: Bool) {
        self.isGiveUp = isGiveUp
    }
    
    var reasonTextOfFailPopupView: String? {
        self.isGiveUp ? "사유: 습관 그만하기" : "사유: 습관 미루기 7회 이상"
    }
}
