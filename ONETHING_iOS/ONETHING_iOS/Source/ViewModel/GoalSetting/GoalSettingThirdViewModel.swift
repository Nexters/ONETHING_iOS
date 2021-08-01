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
    let postponeTodoCountRelay = BehaviorRelay<Int>(value: 5)
    let enableSubject = PublishSubject<Bool>()
    
    func updateHabitTitle(_ title: String) {
        self.habitTitle = title
    }
    
    func updatePushDate(_ date: Date) {
        self.pushDateRelay.accept(date)
    }
    
    func updatePostponeTodo(_ todo: String) {
        self.postponeTodo = todo
        self.checkProccessable()
    }
    
    func updatePostponeCount(_ count: Int) {
        self.postponeTodoCountRelay.accept(count)
    }
    
    func checkProccessable() {
        let enable = self.postponeTodo.isEmpty == false
        self.enableSubject.onNext(enable)
    }
    
    private(set) var habitTitle: String = ""
    private(set) var postponeTodo: String = ""
    private let disposeBag = DisposeBag()
    
}
