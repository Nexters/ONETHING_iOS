//
//  GoalSettingFirstViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import Foundation
import RxSwift

final class GoalSettingFirstViewModel {
    
    let displayListSubjects = [BehaviorSubject<[String]>(value: []), BehaviorSubject<[String]>(value: []),
                               BehaviorSubject<[String]>(value: []), BehaviorSubject<[String]>(value: [])]
    
    init() {
        self.goalListSubject.subscribe(onNext: { goalList in
            guard goalList.count >= 16 else { return }
            
            // 일단은 DEFUALT가 16개 이상으로 정함
            var currentIndex: Int   = 0
            let offset: Int         = 4
            
            self.displayListSubjects.forEach { subject in
                let list = Array(goalList[currentIndex..<currentIndex+offset])
                subject.onNext(list)
                currentIndex += offset
            }
        }).disposed(by: self.disposeBag)
    }
    
    private let goalListSubject = BehaviorSubject<[String]>(value: ["안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요",
                                                                    "안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요",
                                                                    "안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요",
                                                                    "안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요"])
    
    private let disposeBag = DisposeBag()
    
}
