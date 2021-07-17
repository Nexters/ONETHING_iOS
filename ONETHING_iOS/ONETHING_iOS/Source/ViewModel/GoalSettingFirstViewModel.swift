//
//  GoalSettingFirstViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import Foundation
import RxSwift

final class GoalSettingFirstViewModel {
    
    typealias GoalListSection = [[String]]
    
    let reloadFlagSubejct = BehaviorSubject<Void>(value: ())
    
    init() {
        self.goalListSubject.subscribe(onNext: { goalList in
            guard goalList.count >= 16 else { return }
            
            // 일단은 DEFUALT가 16개 이상으로 정함
            var currentIndex: Int   = 0
            let offset: Int         = 4
            
            while currentIndex < 16 {
                let list = Array(goalList[currentIndex..<currentIndex+offset])
                self.goalSection.append(list)
                currentIndex += offset
            }
            self.reloadFlagSubejct.onNext(())
        }).disposed(by: self.disposeBag)
    }
    
    private(set) var goalSection: GoalListSection = []
    
    #warning("Mock 데이터")
    private let goalListSubject = BehaviorSubject<[String]>(value: ["안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요",
                                                                    "저기요", "저기요", "저기요", "저기요",
                                                                    "거기는", "안녕하신가요", "안녕하지요", "당신도 안녕?",
                                                                    "너는 괜찮?", "그럼", "그렇게 괜찮지", "너도?"])
    private let disposeBag = DisposeBag()
    
}
