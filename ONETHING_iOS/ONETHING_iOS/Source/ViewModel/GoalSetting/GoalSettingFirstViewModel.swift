//
//  GoalSettingFirstViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import Foundation
import RxSwift

final class GoalSettingFirstViewModel {
    
    typealias GoalListSection = [RecommendHabitModel]
    
    static let lineHabitOffset: Int = 3
    
    let reloadFlagSubejct = PublishSubject<Void>()
    
    init(apiService: APIService<ContentAPI> = APIService<ContentAPI>()) {
        self.apiService = apiService
        
        self.goalListSubject.subscribe(onNext: { goalList in
            var currentIndex: Int   = 0
            
            while currentIndex < goalList.count {
                let list = Array(goalList[currentIndex..<currentIndex+type(of: self).lineHabitOffset])
                self.habbitSection.append(list)
                currentIndex += type(of: self).lineHabitOffset
            }
            self.reloadFlagSubejct.onNext(())
        }).disposed(by: self.disposeBag)
    }
    
    func requestRecommendedHabbit() {
        let recommendHabbitAPI = ContentAPI.getRecommendedHabit
        self.apiService.requestAndDecode(api: recommendHabbitAPI) { (result: RecommendedHabitResponseModel) in
            guard let recommendedList = result.habitRecommend else { return }
            self.goalListSubject.onNext(recommendedList)
        }
    }
    
    private(set) var habbitSection: [GoalListSection] = []
    private let goalListSubject = BehaviorSubject<GoalListSection>(value: [])
    
    private let apiService: APIService<ContentAPI>
    private let disposeBag = DisposeBag()
    
}
