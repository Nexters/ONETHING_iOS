//
//  GoalSettingFirstViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/12.
//

import Foundation
import RxSwift

final class GoalSettingFirstViewModel {
    
    typealias GoalListSection = [[RecommendHabbitModel]]
    
    let reloadFlagSubejct = BehaviorSubject<Void>(value: ())
    
    init(apiService: APIService<ContentAPI> = APIService<ContentAPI>()) {
        self.apiService = apiService
        
        self.goalListSubject.subscribe(onNext: { goalList in
            var currentIndex: Int   = 0
            let offset: Int         = 3
            
            while currentIndex < goalList.count {
                let list = Array(goalList[currentIndex..<currentIndex+offset])
                self.habbitSection.append(list)
                currentIndex += offset
            }
            self.reloadFlagSubejct.onNext(())
        }).disposed(by: self.disposeBag)
    }
    
    func requestRecommendedHabbit() {
        let recommendHabbitAPI = ContentAPI.getRecommendedHabit
        self.apiService.requestAndDecode(api: recommendHabbitAPI) { (result: RecommendedHabbitResponseModel) in
            guard let recommendedList = result.habitRecommend else { return }
            self.goalListSubject.onNext(recommendedList)
        }
    }
    
    private(set) var habbitSection: GoalListSection = []
    private let goalListSubject = BehaviorSubject<[RecommendHabbitModel]>(value: [])
    
    private let apiService: APIService<ContentAPI>
    private let disposeBag = DisposeBag()
    
}
