//
//  HabitManagingViewModel.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import Foundation

import RxRelay
import RxSwift

protocol GiveUpWarningPopupViewPresentable: AnyObject {
    var currentDayText: String? { get }
    var subTitleTextOfGiveupWarningPopupView: NSAttributedString? { get }
}

protocol FailPopupViewPresentable: AnyObject {
    var titleTextOfFailPopupView: String? { get }
    var progressCountTextOfFailPopupView: String? { get }
    var reasonTextOfFailPopupView: String? { get }
}

final class HabitManagingViewModel: GiveUpWarningPopupViewPresentable, FailPopupViewPresentable {
    let menuRelay = BehaviorRelay(value: HabitManagingViewModel.Menu.allCases)
    var habitInProgressModel: HabitResponseModel?
    let loadingSubject = PublishSubject<Bool>()
    let completeSubject = PublishSubject<Void>()
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func executeReStart() {
        self.loadingSubject.onNext(true)
        
        guard let habitID = self.habitInProgressModel?.habitId else { return }
        let restartAPI: ContentAPI = ContentAPI.putReStart(habitId: habitID)
        self.apiService.requestRx(apiTarget: restartAPI, retryHandler: { [weak self] in
            self?.executeReStart()
        }).subscribe(onSuccess: { response in
            self.loadingSubject.onNext(false)
            
            guard response.statusCode == 200 else { return }
            self.completeSubject.onNext(Void())
        }).disposed(by: self.disposeBag)
    }
    
    func executeGiveUp() {
        self.loadingSubject.onNext(true)
        
        self.apiService.requestAndDecodeRx(
            apiTarget: ContentAPI.putGiveUpHabit,
            retryHandler: nil
        ).subscribe(onSuccess: { [weak self] (habitResponseModel: HabitResponseModel) in
            self?.loadingSubject.onNext(false)
            self?.completeSubject.onNext(Void())
        }).disposed(by: self.disposeBag)
    }
    
    var titleTextOfStartAgainPopupView: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .semiBold),
            size: 16)
        else { return nil }
        
        let titleText = "지금의 습관을\n1일부터 다시 시작하면\n기존의 기록은\n영구적으로 삭제돼요."
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        attributeText.addAttribute(
            .foregroundColor,
            value: UIColor.red_default,
            range: (titleText as NSString).range(of: "기존의 기록은\n영구적으로 삭제돼요.")
        )
        
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
    
    var currentDayText: String? {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return nil }
        
        return String(diffDays + 1)
    }
    
    private var diffDaysFromStartToCurrent: Int? {
        guard let habitInProgressModel = self.habitInProgressModel,
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
    
    var titleTextOfFailPopupView: String? {
        return "아쉽지만\n습관은 여기까지!"
    }
    
    var progressCountTextOfFailPopupView: String? {
        guard let currentDayText = self.currentDayText else {
            return nil
        }

        return "진행: \(currentDayText)일차"
    }
    
    var reasonTextOfFailPopupView: String? {
        return "사유: 습관 그만하기"
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
    
    var subTitleTextOfStartAgainPopupView: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(
            type: .pretendard(weight: .semiBold),
            size: 16)
        else { return nil }
        
        let titleText = "그래도 다시 시작할까요?"
        let attributeText = NSMutableAttributedString(
            string: titleText,
            attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100]
        )
        return attributeText
    }
    
    enum Menu: CaseIterable {
        case startAgain
        case giveup
        
        var order: Int {
            switch self {
            case .startAgain:
                return 0
            case .giveup:
                return 1
            }
        }
        
        var title: String {
            switch self {
            case .startAgain:
                return "1일부터 다시 시작하기"
            case .giveup:
                return "습관 그만하기"
            }
        }
    }
}
