//
//  HabitWrittenViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

import Moya

final class HabitWrittenViewModel {
    private let apiService: APIService<ContentAPI>
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
        
    }
    
    func requestHabitImage() {
        
    }
}
