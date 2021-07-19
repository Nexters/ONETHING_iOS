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
    
    init(provider: MoyaProvider<T> = MoyaProvider<T>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration())])) {
        self.provider = provider
    }
    
    func requestAndDecode<D: Decodable>(api target: T, decodableType: D.Type, completion: @escaping (D) -> Void) {
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
