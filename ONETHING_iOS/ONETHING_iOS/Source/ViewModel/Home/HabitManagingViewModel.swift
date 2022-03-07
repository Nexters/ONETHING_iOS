//
//  HabitManagingViewModel.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

import RxRelay
import RxSwift

final class HabitManagingViewModel: GiveUpWarningPopupViewPresentable {
    let menuRelay = BehaviorRelay(value: HabitManagingViewModel.Menu.allCases)
    private(set) var habitInProgressModel: HabitResponseModel?
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
    
    func update(habitInProgressModel: HabitResponseModel?) {
        self.habitInProgressModel = habitInProgressModel
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

extension HabitManagingViewModel: FailPopupViewPresentable {
    var reasonTextOfFailPopupView: String? {
        return "사유: 습관 그만하기"
    }
}
