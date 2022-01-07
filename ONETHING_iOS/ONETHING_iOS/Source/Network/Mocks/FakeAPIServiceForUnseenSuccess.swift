//
//  FakeAPIServiceForSuccess.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/01/06.
//

import Foundation

import Moya
import RxSwift

final class FakeAPIServiceForUnseenSuccess: APIServiceType {
    let habitID = -1000
    
    func requestAndDecodeRx<C, T>(apiTarget: T, retryHandler: (() -> Void)?) -> Single<C> {
        return Single<C>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getHabitInProgress = contentAPI  {
                single(.success(WrappingHabitResponseModel(data: nil) as! C))
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getUnseenStatus = contentAPI {
                let responseModel: C = WrappingHabitResponseModel(
                    data: HabitResponseModel(
                        habitId: self.habitID,
                        habitStatus: "UNSEEN_SUCCESS",
                        title: "1시간 공부하기",
                        sentence: "다시 힘내자",
                        startDate: "2022.01.01",
                        pushTime: "",
                        delayMaxCount: 6,
                        delayCount: 1,
                        penaltyCount: 5,
                        successCount: 50,
                        color: "blue")) as! C
                single(.success(responseModel))
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getDailyHistories = contentAPI {
                let responseModel: C = DailyHabitsResponseModel(
                    histories: [DailyHabitResponseModel(
                                    habitId: self.habitID,
                                    status: "DELAY_PENALTY",
                                    createDateTime: "2021.01.01",
                                    stampType: "delay")]) as! C
                single(.success(responseModel))
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .putUnSeenSuccess(habitId: self.habitID) = contentAPI {
                single(.success(true as! C))
            }
            
            return Disposables.create()
        }
    }
    
}
