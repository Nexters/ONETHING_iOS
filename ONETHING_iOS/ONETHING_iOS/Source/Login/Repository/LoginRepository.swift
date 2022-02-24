//
//  LoginRepository.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/24.
//

import RxSwift
import Foundation

protocol LoginRepository {
    func requestAppleLogin(authorizationCode: String, identityToken: String, userName: String?) -> Observable<LoginResponseModel>
    func reqeustKakaoLogin(accessToken: String, refreshToken: String, refreshExpiresIn: TimeInterval, scope: String) -> Observable<LoginResponseModel>
}

final class LoginRepositoryImpl: LoginRepository {

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func requestAppleLogin(authorizationCode: String, identityToken: String, userName: String?) {
        
    }
    
    func reqeustKakaoLogin(accessToken: String, refreshToken: String, refreshExpiresIn: TimeInterval, scope: String) {
        
    }
    
    private let apiService: APIService
    
}
