//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation
import Moya
import RxSwift

final class APIService<T: TargetType> {
    private let provider: MoyaProvider<T>
    private let jsonDecoder = JSONDecoder()

    init(provider: MoyaProvider<T> = MoyaProvider<T>(session: DefaultSession.sharedInstance)) {
        self.provider = provider
    }
    
    static func requestAndDecodeRx<C: Codable>(apiTarget: T, retryHandler: (() -> Void)? = nil) -> Single<C> {
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
                    guard NetworkErrorPopupView.isPresented == false                                    else { return }
                    guard let networkPopupView: NetworkErrorPopupView = UIView.createFromNib()          else { return }
                    guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    networkPopupView.show(in: keyWindow) { retryHandler?() }
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
    
    func requestAndDecode<D: Decodable>(
        api target: T,
        comepleteHandler: @escaping (D) -> Void,
        errorHandler: ((Error) -> Void)? = nil,
        retryHandler: (() -> Void)? = nil
    ) {
        let key = String(describing: target.self)
        let request = provider.request(target) { [weak self] result in
            guard let self = self else { self?.cancelAllRequest(); return }
            
            switch result {
            case .success(let response):
                if let onethingError = response.onethingError {
                    OnethingErrorHandler.sharedInstance.handleError(onethingError)
                    errorHandler?(onethingError)
                    
                    // ExpiredAccessToken이 만료된 경우, 1초 뒤에 해당 API 재요청
                    guard onethingError == .expiredAccessToken else { return }
                    DispatchQueue.executeAyncAfter(on: .onethingNetworkQueue, deadline: .now() + 1.5) { [weak self] in
                        guard self != nil else { self?.cancelAllRequest(); return }
                        self?.requestAndDecode(api: target, comepleteHandler: comepleteHandler)
                    }
                    return
                }
                
                if let userAPI = target as? UserAPI, case .logout = userAPI {
                    if response.statusCode == 200 { comepleteHandler(true as! D) }
                    else { comepleteHandler(false as! D) }
                }
                
                self.decode(with: response, comepleteHandler: comepleteHandler, errorHandler: errorHandler)
            case .failure(let error):
                errorHandler?(error as Error)
                guard NetworkErrorPopupView.isPresented == false                                    else { return }
                guard let networkPopupView: NetworkErrorPopupView = UIView.createFromNib()          else { return }
                guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                networkPopupView.show(in: keyWindow) { retryHandler?() }
            }
        }
    
        self.requestTable.updateValue(request, forKey: key)
    }
    
    func request(api target: T, completionHandler: @escaping (Data) -> Void) {
        self.provider.request(target) { result in
            switch result {
                case.success(let response):
                    completionHandler(response.data)
                case .failure(_):
                    break
            }
        }
    }
    
    private func decode<D: Decodable>(
        with response: Moya.Response,
        comepleteHandler: @escaping (D) -> Void,
        errorHandler: ((Error) -> Void)?) {
        do {
            guard let jsonData = try response.mapString().data(using: .utf8) else {
                throw NSError(domain: "JSON Parsing Error", code: -1, userInfo: nil)
            }
            
            let decodedModel = try self.jsonDecoder.decode(D.self, from: jsonData)
            comepleteHandler(decodedModel)
        } catch {
            errorHandler?(error)
        }
    }
    
    private func cancelAllRequest() {
        self.requestTable.forEach { $1.cancel() }
    }
    
    private var requestTable: [String: Cancellable] = [:]
    
}
