//
//  FakeAPIServiceForUnseenFail.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/09/01.
//

import Foundation

import Moya
import RxSwift

final class FakeAPIServiceForUnseenFail: APIServiceType {
    let habitId = -1000
    
    enum HabitResponseOrder {
        case 실패_닫기_버튼_누르기전
        case 실패_닫기_버튼_누른후
    }
    
    private var order: HabitResponseOrder = .실패_닫기_버튼_누르기전
    
    func requestAndDecodeRx<C: Codable, T: TargetType>(apiTarget: T, retryHandler: (() -> Void)? = nil) -> Single<C> {
        return Single<C>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getHabitInProgress = contentAPI  {
                switch self.order {
                    case .실패_닫기_버튼_누르기전:
                        single(.success(WrappingHabitResponseModel(data: nil) as! C))
                    case .실패_닫기_버튼_누른후:
                        single(.success(WrappingHabitResponseModel(data: nil) as! C))
                }
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getUnseenStatus = contentAPI {
                switch self.order {
                    case .실패_닫기_버튼_누르기전:
                        single(.success(WrappingHabitResponseModel(data: HabitResponseModel(habitId: self.habitId, habitStatus: "UNSEEN_FAIL", title: "1시간 공부하기", sentence: "다시 힘내자", startDate: "2021.08.29", pushTime: "", delayMaxCount: 6, delayCount: 1, penaltyCount: 5, successCount: 2, color: "blue")) as! C))
                    default:
                        break
                }
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .getDailyHistories = contentAPI {
                switch self.order {
                    case .실패_닫기_버튼_누르기전:
                        single(.success(DailyHabitsResponseModel(histories: [DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"), DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay"),
                            DailyHabitResponseModel(habitId: self.habitId, status: "DELAY_PENALTY", createDateTime: "2021.08.29", stampType: "delay")]) as! C))
                    case .실패_닫기_버튼_누른후:
                        single(.success(DailyHabitsResponseModel(histories: []) as! C))
                }
            }
            
            if let contentAPI = apiTarget as? ContentAPI, case .putUnSeenFail = contentAPI {
                self.order = .실패_닫기_버튼_누른후
                single(.success(true as! C))
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
