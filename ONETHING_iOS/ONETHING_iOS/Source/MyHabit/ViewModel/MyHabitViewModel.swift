//
//  MyHabitViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import RxSwift
import Foundation
import RxRelay

final class MyHabitViewModel {
    let loadingSubject = BehaviorSubject<Bool>(value: false)
    
    var habitListObservable: Observable<[HabitResponseModel]> {
        self.habitListRelay.asObservable()
    }
    
    var habitCountObservable: Observable<Int> {
        self.habitListRelay.map { $0.count }
    }
    
    var currentPageObservable: Observable<Int> {
        self.currentPageRelay.asObservable()
    }
    
    init(habitRepository: HabitRepository = HabitRepositoryImpl()) {
        self.habitRepository = habitRepository
    }
    
    func occur(viewEvent: ViewEvent) {
        switch viewEvent {
        case .viewDidLoad:
            self.fetchHabitHistory()
        case .scroll(let page):
            self.updateCurrentPage(page)
        }
    }
    
    private func fetchHabitHistory() {
        self.loadingSubject.onNext(true)
        self.habitRepository.fetchAllHabit()
            .do(onDispose:  { [weak self] in
                self?.emitLoadingAfter(time: .now() + 0.1, value: false)
            })
            .map { habitList in
                habitList.filter { $0.onethingHabitStatus?.canShowHistoryPage == true }
            }
            .bind(to: self.habitListRelay)
            .disposed(by: self.disposeBag)
    }
    
    private func emitLoadingAfter(time: DispatchTime, value: Bool) {
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.loadingSubject.onNext(value)
        })
    }
    
    private func updateCurrentPage(_ page: Int) {
        self.currentPageRelay.accept(page)
    }
    
    private let disposeBag = DisposeBag()
    private let habitRepository: HabitRepository
    
    private let habitListRelay = PublishRelay<[HabitResponseModel]>()
    private let currentPageRelay = BehaviorRelay<Int>(value: 0)

}

extension MyHabitViewModel {
    
    enum ViewEvent {
        case viewDidLoad
        case scroll(page: Int)
    }
    
}
