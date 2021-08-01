//
//  GoalSettingFinishViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation
import RxSwift

final class GoalSettingFinishViewModel {
    
    let loadingSubject = PublishSubject<Bool>()
    let completeSubject = PublishSubject<Void>()
    
    init(apiService: APIService<ContentAPI> = APIService<ContentAPI>()) {
        self.apiService = apiService
    }
    
    func updateHabitInformation(_ title: String, _ postponeTodo: String, _ pushTime: Date, _ postponeCount: Int) {
        self.habitTitle = title
        self.postponeTodo = postponeTodo
        self.pushTime = pushTime
        self.postponeCount = postponeCount
    }
    
    func requestCreateHabit() {
        guard let title = self.habitTitle            else { return }
        guard let sentence = self.postponeTodo       else { return }
        guard let pushTime = self.pushTime           else { return }
        guard let postponeCount = self.postponeCount else { return }
        
        let createHabitAPI = ContentAPI.createHabit(title: title, sentence: sentence,
                                                    pushTime: pushTime.convertString(), delayMaxCount: postponeCount)
        self.loadingSubject.onNext(true)
        apiService.requestAndDecode(api: createHabitAPI, comepleteHandler: { [weak self] (responseModel: CreateHabitResponseModel) in
            print(responseModel)
            self?.loadingSubject.onNext(false)
            self?.completeSubject.onNext(())
        }, errorHandler: { [weak self] error in
            #warning("여기서 Error 차리 따로 필요한 경우")
            self?.loadingSubject.onNext(false)
            print(error.localizedDescription)
        })
    }
    
    private let disposeBag = DisposeBag()
    
    private let apiService: APIService<ContentAPI>
    
    private(set) var habitTitle: String?
    private(set) var postponeTodo: String?
    private(set) var pushTime: Date?
    private(set) var postponeCount: Int?
}
