//
//  GoalSettingThirdViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/18.
//

import Foundation
import RxSwift
import RxRelay

final class GoalSettingThirdViewModel {
    
    let pushDateRelay = BehaviorRelay<Date>(value: Date())
    let postponeTodoRelay = BehaviorRelay<String>(value: "")
    
    func updatePushDate(_ date: Date) {
        self.pushDateRelay.accept(date)
    }
    
    
    
    private let disposeBag = DisposeBag()
    
}
