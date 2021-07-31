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
                
                do {
                    let decodedModel = try self.jsonDecoder.decode(D.self, from: response.data)
                    comepleteHandler(decodedModel)
                } catch let error {
                    errorHandler?(error)
                }
            case .failure:
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
    
    private func cancelAllRequest() {
        self.requestTable.forEach { $1.cancel() }
    }
    
    private var requestTable: [String: Cancellable] = [:]
    
}
