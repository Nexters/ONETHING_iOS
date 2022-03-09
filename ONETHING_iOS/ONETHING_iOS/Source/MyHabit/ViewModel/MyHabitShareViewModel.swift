//
//  MyHabitShareViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import RxSwift
import Foundation
import RxRelay

final class MyHabitShareViewModel {
    
    var selectShareTypeObservable: Observable<HabitShareType> {
        self.selectShareTypeRelay.asObservable()
    }
    
    var habitObservable: Observable<MyHabitCellPresentable> {
        self.habitRelay.compactMap { $0 }
    }
    
    func setShareHabit(_ habit: MyHabitCellPresentable) {
        self.habitRelay.accept(habit)
    }
    
    func occur(viewEvent: ViewEvent) {
        switch viewEvent {
        case .didTapShareButton(let type):
            self.selectShareType(type)
        }
    }
    
    private func selectShareType(_ type: HabitShareType) {
        self.selectShareTypeRelay.accept(type)
    }
    
    private let disposeBag = DisposeBag()
    
    private let selectShareTypeRelay = BehaviorRelay<HabitShareType>(value: .first)
    private let habitRelay = BehaviorRelay<MyHabitCellPresentable?>(value: nil)
    
}

extension MyHabitShareViewModel {
    
    enum ViewEvent {
        case didTapShareButton(type: HabitShareType)
    }
    
}
