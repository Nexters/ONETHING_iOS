//
//  APIService.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import Foundation

import Moya

final class ApiService {
    private let provider: MoyaProvider<Api>
    private let jsonDecoder = JSONDecoder()
    
    init(provider: MoyaProvider<Api> = MoyaProvider<Api>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration())])) {
        self.provider = provider
    }
    
    func requestAndDecode<T: Decodable>(api target: Api, decodableType: T.Type, completion: @escaping (T) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                guard let decodedModel = try? self.jsonDecoder.decode(decodableType, from: response.data) else { return }
                
                completion(decodedModel)
            case .failure(_):
                break
            }
        }
    }
}
