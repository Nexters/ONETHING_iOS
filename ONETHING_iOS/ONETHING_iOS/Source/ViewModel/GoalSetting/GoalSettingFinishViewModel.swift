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
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func updateHabitInformation(_ title: String, _ postponeTodo: String, _ pushTime: Date, _ postponeCount: Int) {
        self.habitTitle = title
        self.postponeTodo = postponeTodo
        self.pushTime = pushTime
        self.penaltyCount = postponeCount
    }
    
    func requestCreateHabit() {
        guard let title = self.habitTitle            else { return }
        guard let sentence = self.postponeTodo       else { return }
        guard let pushTime = self.pushTime           else { return }
        guard let postponeCount = self.penaltyCount else { return }
        
        let createHabitAPI = ContentAPI.createHabit(title: title, sentence: sentence,
                                                    pushTime: pushTime.convertString(), penaltyCount: postponeCount)
        self.loadingSubject.onNext(true)
        self.apiService.requestAndDecodeRx(apiTarget: createHabitAPI)
            .subscribe(onSuccess: { [weak self] (responseModel: HabitResponseModel) in
                self?.loadingSubject.onNext(false)
                OnethingUserManager.sharedInstance.updateDoneHabitSetting(true)
                self?.completeSubject.onNext(())
            }, onFailure: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            }).disposed(by: self.disposeBag)
    }
    
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
    private(set) var habitTitle: String?
    private(set) var postponeTodo: String?
    private(set) var pushTime: Date?
    private(set) var penaltyCount: Int?
}
