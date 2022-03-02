//
//  HabitManagingViewModel.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import Foundation

import RxRelay

final class HabitManagingViewModel {
    let menuRelay = BehaviorRelay(value: HabitManagingViewModel.Menu.allCases)
    
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
