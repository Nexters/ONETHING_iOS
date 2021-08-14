//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation
import Moya
import RxSwift

final class APIService {
    static let shared = APIService()
    
    func requestAndDecodeRx<C: Codable, T: TargetType>(apiTarget: T, retryHandler: (() -> Void)? = nil) -> Single<C> {
        return Single<C>.create { single in
            let provider = MoyaProvider<T>(session: DefaultSession.sharedInstance)
            let request = provider.request(apiTarget) { result in
                switch result {
                case .success(let response):
                    if let onethingError = response.onethingError {
                        OnethingErrorHandler.sharedInstance.handleError(onethingError)
                        single(.failure(onethingError))
                        return
                    }
                    
                    if let userAPI = apiTarget as? UserAPI, case .logout = userAPI {
                        if response.statusCode == 200 { single(.success(true as! C)) }
                        else                          { single(.success(false as! C)) }
                    }
                    
                    if let contentAPI = apiTarget as? ContentAPI, case .getDailyHabitImage = contentAPI {
                        if response.statusCode == 200 { single(.success(response.data as! C)) }
                    }
                    
                    do {
                        guard let resultData = try response.mapString().data(using: .utf8) else {
                            throw NSError(domain: "JSON Parsing Error", code: -1, userInfo: nil)
                        }
                        
                        let responseJson = try JSONDecoder().decode(C.self, from: resultData)
                        single(.success(responseJson))
                    } catch let error {
                        single(.failure(error))
                    }
                case .failure:
                    if NetworkErrorPopupView.presentedView == nil {
                        NetworkErrorPopupView.showInKeyWindow { retryHandler?() }
                    } else {
                        NetworkErrorPopupView.append { retryHandler?() }
                    }
                }
            }
            
            return Disposables.create { request.cancel() }
        }.retry { errorObservable -> Observable<Int> in
            return errorObservable.flatMap { error -> Observable<Int> in
                let onethingError = error as? OnethingError
                if onethingError == .expiredAccessToken {
                    return Observable<Int>.timer(.milliseconds(1500), scheduler: MainScheduler.instance)
                }
                return Observable.error(error)
            }
        }
    }
}
