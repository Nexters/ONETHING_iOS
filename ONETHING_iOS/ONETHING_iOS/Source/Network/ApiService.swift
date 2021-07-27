//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation
import Moya

final class ApiService<T: TargetType> {
    private let provider: MoyaProvider<T>
    private let jsonDecoder = JSONDecoder()
    
    init(provider: MoyaProvider<T> = MoyaProvider<T>(session: DefaultSession.sharedInstance)) {
        self.provider = provider
    }
    
    func requestAndDecode<D: Decodable>(
        api target: T,
        completion: @escaping (D) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if let onethingErrorModel = response.onethingErrorModel,
                   let onethingError = onethingErrorModel.onethingError {
                    ErrorHandler.sharedInstance.handleError(onethingError)
                    
                    // ExpiredAccessToken이 만료된 경우, 1초 뒤에 해당 API 재요청
                    guard onethingError == .expiredAccessToken else { return }
                    DispatchQueue.executeAyncAfter(on: .onethingNetworkQueue, deadline: .now() + 1) { [weak self] in
                        guard self != nil else { return }
                        self?.requestAndDecode(api: target, completion: completion)
                    }
                    return
                }
                
                guard let decodedModel = try? self.jsonDecoder.decode(D.self, from: response.data) else { return }
                completion(decodedModel)
            case .failure(_):
                break
            }
        }
    }
    
}
