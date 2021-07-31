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
    let postponeTodoCountRelay = BehaviorRelay<Int>(value: 5)
    let enableSubject = PublishSubject<Bool>()
    
    func updatePushDate(_ date: Date) {
        self.pushDateRelay.accept(date)
    }
    
    func updatePostponeTodo(_ todo: String) {
        self.postponeTodoRelay.accept(todo)
        self.checkProccessable()
    }
    
    func updatePostponeCount(_ count: Int) {
        self.postponeTodoCountRelay.accept(count)
    }
    
    func checkProccessable() {
        let enable = self.postponeTodoRelay.value.isEmpty == false
        self.enableSubject.onNext(enable)
    }
    
    private let disposeBag = DisposeBag()
    
}
