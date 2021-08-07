//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation
import Moya

final class APIService<T: TargetType> {
    private let provider: MoyaProvider<T>
    private let jsonDecoder = JSONDecoder()
    
    init(provider: MoyaProvider<T> = MoyaProvider<T>(session: DefaultSession.sharedInstance)) {
        self.provider = provider
    }
    
    func requestAndDecode<D: Decodable>(
        api target: T,
        comepleteHandler: @escaping (D) -> Void,
        errorHandler: ((Error) -> Void)? = nil
    ) {
        let key = String(describing: target.self)
        let request = provider.request(target) { [weak self] result in
            guard let self = self else { self?.cancelAllRequest(); return }
            
            switch result {
            case .success(let response):
                if let onethingErrorModel = response.onethingErrorModel,
                   let onethingError = onethingErrorModel.onethingError {
                    OnethingErrorHandler.sharedInstance.handleError(onethingError)
                    errorHandler?(onethingError)

                    // ExpiredAccessToken이 만료된 경우, 1초 뒤에 해당 API 재요청
                    guard onethingError == .expiredAccessToken else { return }
                    DispatchQueue.executeAyncAfter(on: .onethingNetworkQueue, deadline: .now() + 1) { [weak self] in
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
                #warning("여기 Network 아닌 경우도 떨어지긴하는데, 대체로 네트워크라.. 일단..")
                guard let networkPopupView: NetworkErrorPopupView = UIView.createFromNib() else { return }
                guard let visibleController = UIViewController.getVisibleController() else { return }
                networkPopupView.show(in: visibleController.view) { [weak self] in
                    self?.requestAndDecode(api: target, comepleteHandler: comepleteHandler, errorHandler: errorHandler)
                }
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
            print(String(data: jsonData, encoding: .utf8)!)
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
