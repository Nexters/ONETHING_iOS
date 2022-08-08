//
//  ProfileViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import RxRelay
import RxSwift
import Foundation

final class ProfileViewModel {
    
    let menuRelay = BehaviorRelay<[Menu]>(value: Menu.allCases)
    let userRelay = BehaviorRelay<OnethingUserModel?>(value: nil)
    let successCountRelay = BehaviorRelay<Int>(value: 0)
    let delayCountRelay = BehaviorRelay<Int>(value: 0)
    let loadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func requestUserInform() {
        self.loadingRelay.accept(true)
        
        let accountAPI = UserAPI.account
        self.apiService.requestAndDecodeRx(apiTarget: accountAPI, retryHandler: { [weak self] in
            self?.requestUserInform()
        }).subscribe(onSuccess: { [weak self] (accountModel: OnethingAccountModel) in
            self?.loadingRelay.accept(false)
            
            guard let self = self else { return }
            guard let account = accountModel.account else { return }
            self.userRelay.accept(account)
        }).disposed(by: self.disposeBag)
    }
    
    func requestHabits() {
        self.loadingRelay.accept(true)
        
        let habitAPI = ContentAPI.getHabits
        self.apiService.requestAndDecodeRx(apiTarget: habitAPI, retryHandler: { [weak self] in
            self?.requestUserInform()
            self?.requestHabits()
        }).subscribe(onSuccess: { [weak self] (habitReseponseModel: [HabitResponseModel]) in
            self?.loadingRelay.accept(false)
            
            var totalSuccessCount: Int = 0
            var totalDelayCount: Int = 0
            
            habitReseponseModel.forEach { habit in
                totalDelayCount += habit.delayCount
                totalSuccessCount += habit.successCount
            }
            self?.successCountRelay.accept(totalSuccessCount)
            self?.delayCountRelay.accept(totalDelayCount)
        }).disposed(by: self.disposeBag)
    }
    
    private let apiService: APIService
    
    private let disposeBag = DisposeBag()
    
}

extension ProfileViewModel {
    
    enum Menu: Int, CaseIterable {
        case myAccount = 0
        case notice
        case question
        case makePeople
        case openSource
        
        var title: String {
            switch self {
            case .myAccount:    return "내 계정"
            case .notice:       return "공지사항"
            case .question:     return "자주 묻는 질문"
            case .makePeople:   return "만든 사람들"
            case .openSource:   return "오픈소스 라이센스"
            }
        }
    }
    
}
