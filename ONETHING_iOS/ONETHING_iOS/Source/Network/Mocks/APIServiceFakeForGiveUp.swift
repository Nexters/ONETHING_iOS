//
//  APIServiceStubForGiveup.swift
//  ONETHING
//
//  Created by sdean on 2021/09/01.
//

import Foundation

import RxSwift
import Moya

final class APIServiceFakeForGiveUp: APIServiceType {
    let habitId = -1000
    
    enum DailyHabitsOrder {
        case 습관_포기하기전
        case 습관_포기한_이후
    }
    
    var order: DailyHabitsOrder = .습관_포기하기전
    
    func requestAndDecodeRx<C: Codable, T: TargetType>(apiTarget: T, retryHandler: (() -> Void)? = nil) -> Single<C> {
        return Single<C>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getHabitInProgress = contentAPI  {
                single(.success(WrappingHabitResponseModel(data: HabitResponseModel(habitId: self.habitId, habitStatus: "RUN", title: "1시간 공부하기", sentence: "다시 힘내자", startDate: "2021.08.29", pushTime: "", delayMaxCount: 6, delayCount: 1, penaltyCount: 5, successCount: 2, color: "blue")) as! C))
                
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getDailyHistories = contentAPI {
                if self.order == .습관_포기하기전 {
                    single(.success(DailyHabitsResponseModel(histories: [DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay")]) as! C))
                    self.order = .습관_포기한_이후
                } else if self.order == .습관_포기한_이후 {
                    single(.success(DailyHabitsResponseModel(histories: [DailyHabitResponseModel(habitId: self.habitId, status: "DELAY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY", createDateTime: "2021.08.29", stampType: "delay")]) as! C))
                }
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .putGiveUpHabit = contentAPI {
                single(.success(HabitResponseModel(habitId: self.habitId, habitStatus: "RUN", title: "1시간 공부하기", sentence: "다시 힘내자", startDate: "2021.08.29", pushTime: "", delayMaxCount: 6, delayCount: 1, penaltyCount: 5, successCount: 2, color: "blue") as! C))
            }
            
            return Disposables.create()
        }
    }
}

