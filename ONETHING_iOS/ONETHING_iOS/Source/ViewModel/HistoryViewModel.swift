//
//  HistoryViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

import Moya

final class HistoryViewModel {
    private let apiService: APIService<ContentAPI>
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func requestTotalHistories() {
        self.apiService.requestAndDecode(api: .getHabits) { [weak self] (habitResponseModels: [HabitResponseModel]) in
            
        }
    }
}
