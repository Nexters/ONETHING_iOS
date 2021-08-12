//
//  HistoryViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

import Moya
import RxSwift

final class HistoryViewModel {
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func requestTotalHistories() {
        self.apiService.requestAndDecodeRx(apiTarget: ContentAPI.getHabits)
            .subscribe(onSuccess: { (dailyHabits: DailyHabitsResponseModel) in })
            .disposed(by: self.disposeBag)
    }
}
