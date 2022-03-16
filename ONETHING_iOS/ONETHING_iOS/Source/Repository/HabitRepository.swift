//
//  ContentRepository.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import RxSwift
import Foundation

protocol HabitRepository {
    func fetchAllHabit() -> Observable<[HabitResponseModel]>
}

final class HabitRepositoryImpl: HabitRepository {

    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchAllHabit() -> Observable<[HabitResponseModel]> {
        let allHabitAPI = ContentAPI.getHabits
        return self.apiService.requestRx(apiTarget: allHabitAPI, retryHandler: nil)
            .asObservable()
            .map { response in
                ModelDecoder.decodeData(fromData: response.data, toType: [HabitResponseModel].self) ?? []
            }
    }
    
    private let apiService: APIServiceType
}
