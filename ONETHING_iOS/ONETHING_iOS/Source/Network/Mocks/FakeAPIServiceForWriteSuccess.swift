//
//  FakeAPIServiceForWriteSuccess.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/01/06.
//

import Foundation

import Moya
import RxSwift

final class FakeAPIServiceForWriteSuccess: APIServiceType {
    let habitID = -1000
    
    enum HabitResponseOrder {
        case 성공_닫기_버튼_누르기전
        case 성공_닫기_버튼_누른후
    }
    
    private var order: HabitResponseOrder = .성공_닫기_버튼_누르기전
    
    func requestAndDecodeRx<C, T>(apiTarget: T, retryHandler: (() -> Void)?) -> Single<C> {
        return Single<C>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getHabitInProgress = contentAPI  {
                switch self.order {
                    case .성공_닫기_버튼_누르기전:
                        let responseModel: C = WrappingHabitResponseModel(
                            data: HabitResponseModel(
                                habitId: self.habitID,
                                habitStatus: "RUN",
                                title: "1시간 공부하기",
                                sentence: "다시 힘내자",
                                startDate: "2021.11.03",
                                pushTime: "",
                                delayMaxCount: 7,
                                delayCount: 1,
                                penaltyCount: 5,
                                successCount: 64,
                                color: "blue")
                        ) as! C
                        single(.success(responseModel))
                    case .성공_닫기_버튼_누른후:
                        single(.success(WrappingHabitResponseModel(data: nil) as! C))
                }
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getDailyHistories = contentAPI {
                var historyModels = [DailyHabitResponseModel(
                    habitId: self.habitID,
                    status: "DELAY",
                    createDateTime: "2021.01.01",
                    stampType: "delay")]
                let sucessModels = [DailyHabitResponseModel].init(
                    repeating: DailyHabitResponseModel(
                        habitId: self.habitID,
                        status: "SUCCESS",
                        createDateTime: "2021.01.02"
                    ),
                    count: 64)
                historyModels.append(contentsOf: sucessModels)
                
                let responseModel: C = DailyHabitsResponseModel(
                    histories: historyModels) as! C
                
                self.order = .성공_닫기_버튼_누른후
                
                single(.success(responseModel))
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getUnseenStatus = contentAPI {
                switch self.order {
                    case .성공_닫기_버튼_누른후:
                        single(.success(WrappingHabitResponseModel(data: nil) as! C))
                    default:
                        break
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestRx<T: TargetType>(apiTarget: T, retryHandler: (() -> Void)?) -> Single<Response> {
        return Single<Response>.create { single in
            return Disposables.create { }
        }
    }
    
}
