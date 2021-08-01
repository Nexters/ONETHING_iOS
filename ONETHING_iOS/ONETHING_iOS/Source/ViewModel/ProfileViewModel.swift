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
    
    private let disposeBag = DisposeBag()
    
}

extension ProfileViewModel {
    
    enum Menu: Int, CaseIterable {
        case myAccount = 0
        case pushSetting
        case fontSetting
        case announce
        case question
        
        var title: String {
            switch self {
            case .myAccount: return "내 계정"
            case .pushSetting: return "알림 설정"
            case .fontSetting: return "폰트 설정"
            case .announce: return "공지사항"
            case .question: return "자주 묻는 질문"
            }
        }
    }
    
}
