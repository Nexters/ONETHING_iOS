//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation
import Moya
import RxSwift

protocol APIServiceType {
    func requestRx<T: TargetType>(apiTarget: T, retryHandler: (() -> Void)?) -> Single<Response>
    func requestAndDecodeRx<C: Codable, T: TargetType>(apiTarget: T, retryHandler: (() -> Void)?) -> Single<C>
}

final class APIService: APIServiceType {
    
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
                    
                    if let contentAPI = apiTarget as? ContentAPI, case .getDailyHabitImage = contentAPI {
                        if response.statusCode == 200 { single(.success(response.data as! C)) }
                    }
                    
                    if let contentAPI = apiTarget as? ContentAPI, case .putPassDelayPenalty = contentAPI {
                        if response.statusCode == 200 {
                            single(.success(true as! C))
                        }
                    }
                    
                    if let contentAPI = apiTarget as? ContentAPI, case .putUnSeenFail = contentAPI {
                        if response.statusCode == 200 {
                            single(.success(true as! C))
                        }
                    }
                    
                    if let contentAPI = apiTarget as? ContentAPI, case .putUnSeenSuccess = contentAPI {
                        if response.statusCode == 200 {
                            single(.success(true as! C))
                        }
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
                case .failure(let error):
                    single(.failure(error))
                    self.handleNetworkDisconnectIfNeeded(withHandler: retryHandler)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
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
    
    func requestRx<T: TargetType>(apiTarget: T, retryHandler: (() -> Void)? = nil) -> Single<Response> {
        Single<Response>.create { single in
            let provider = MoyaProvider<T>(session: DefaultSession.sharedInstance)
            let request = provider.request(apiTarget) { [weak self] result in
                switch result {
                case .success(let response):
                    if let onethingError = response.onethingError {
                        OnethingErrorHandler.sharedInstance.handleError(onethingError)
                        single(.failure(onethingError))
                        return
                    }
                    
                    single(.success(response))
                case .failure(let error):
                    self?.handleNetworkDisconnectIfNeeded(withHandler: retryHandler)
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        .retry(when: { errorObservable -> Observable<Int> in
            errorObservable.flatMap { error -> Observable<Int> in
                let onethingError = error as? OnethingError
                if onethingError == .expiredAccessToken {
                    return Observable<Int>.timer(.milliseconds(1500), scheduler: MainScheduler.instance)
                }
                return Observable.error(error)
            }
        })
    }
    
    private func handleNetworkDisconnectIfNeeded(withHandler handler: (() -> Void)? = nil) {
        guard NetworkDetector.shared.isConnected == false else { return }
        if NetworkErrorPopupView.presentedView == nil {
            NetworkErrorPopupView.showInKeyWindow { handler?() }
        } else {
            NetworkErrorPopupView.append { handler?() }
        }
    }
    
}
