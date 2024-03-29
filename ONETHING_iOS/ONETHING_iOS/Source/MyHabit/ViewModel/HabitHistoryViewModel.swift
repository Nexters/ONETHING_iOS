//
//  HabitHistoryViewModel.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

import RxSwift
import RxRelay

final class HabitHistoryViewModel {
    static let defaultTotalDays = 66
    
    let loadingSubject = PublishSubject<Bool>()
    let completeSubject = PublishSubject<Void>()
    let dailyHabitsRelay = BehaviorRelay<[DailyHabitResponseModel]>(value: [])
    
    private let apiService: APIService
    private(set) var presentable: MyHabitCellPresentable?
    let habitInfoViewModel: HabitInfoViewModel
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService = APIService.shared, presentable: MyHabitCellPresentable?) {
        self.apiService = apiService
        self.presentable = presentable
        self.habitInfoViewModel = HabitInfoViewModel(presentable: presentable)
    }
    
    func dailyHabitResponseModel(at index: Int) -> DailyHabitResponseModel? {
        let dailyHabits = self.dailyHabitsRelay.value
        return dailyHabits[safe: index]
    }
    
    func fetchDailyHabits() {
        guard let habitID = self.presentable?.habitId else { return }
        
        self.loadingSubject.onNext(true)
        let apiTarget = ContentAPI.getDailyHistories(habitId: habitID)
        self.apiService.requestRx(apiTarget: apiTarget, retryHandler: nil)
            .asObservable()
            .do(onDispose: { [weak self] in
                self?.loadingSubject.onNext(false)
            })
            .compactMap { response -> DailyHabitsResponseModel? in
                ModelDecoder.decodeData(fromData: response.data, toType: DailyHabitsResponseModel.self)
            }
            .map { $0.histories }
            .bind(to: self.dailyHabitsRelay)
            .disposed(by: self.disposeBag)
    }
    
    func deleteHabit() {
        guard let habitID = self.presentable?.habitId else { return }
        
        self.loadingSubject.onNext(true)
        let deleteAPI: ContentAPI = ContentAPI.deleteHabit(habitId: habitID)
        self.apiService.requestRx(apiTarget: deleteAPI, retryHandler: { [weak self] in
            self?.deleteHabit()
        }).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.loadingSubject.onNext(false)
            
            guard response.statusCode == 200 else { return }
            self.completeSubject.onNext(Void())
        }).disposed(by: self.disposeBag)
    }
    
    var dailyHabitsThatHasImage: [DailyHabitResponseModel] {
        let dailyHabitsThatHasImage = self.dailyHabitsRelay.value.filter { dailyHabitResponseModel in
            return dailyHabitResponseModel.hasImageData
        }
        
        return dailyHabitsThatHasImage
    }
    
    var dailyHabitsThatHasDocuments: [DailyHabitResponseModel] {
        let dailyHabitsThatHasDocuments = self.dailyHabitsRelay.value.filter { dailyHabitResponseModel in
            let hasContent = dailyHabitResponseModel.hasDocument
            if hasContent { return true }
            else if dailyHabitResponseModel.isDelayStamp { return true }
            else { return false }
        }
        
        return dailyHabitsThatHasDocuments
    }
}

extension HabitHistoryViewModel: TitleSubTitleConfirmViewModel {
    var titleText: NSAttributedString? {
        guard let presentable = self.presentable,
              let pretendardFont = UIFont.createFont(
                type: .pretendard(weight: .semiBold),
                size: 16)
        else { return nil }
        
        let titleText = "\(presentable.title)\n습관 기록을 정말로\n삭제하시겠어요?"
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        attributeText.addAttribute(
            .foregroundColor,
            value: UIColor.red_default,
            range: (titleText as NSString).range(of: presentable.title)
        )
        
        return attributeText.with(lineSpacing: 4.0)
    }
    
    var subTitleText: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .regular),
            size: 12)
        else { return nil }
        
        let titleText = "한번 삭제하면\n다신 복구할 수 없어요!"
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        return attributeText
    }
}
