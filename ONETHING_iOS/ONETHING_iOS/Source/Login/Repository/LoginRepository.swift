//
//  LoginRepository.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/24.
//

import RxSwift
import Foundation

protocol LoginRepository {
    func requestAppleLogin(requestBody: AppleLoginRequestBody, retryHandler: (() -> Void)?) -> Observable<LoginResponseModel>
    func reqeustKakaoLogin(requestBody: KakaoLoginReqeustBody, retryHandler: (() -> Void)?) -> Observable<LoginResponseModel>
}

final class LoginRepositoryImpl: LoginRepository {

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func requestAppleLogin(requestBody: AppleLoginRequestBody, retryHandler: (() -> Void)? = nil) -> Observable<LoginResponseModel> {
        let appleLoginAPI = UserAPI.appleLogin(
            authorizationCode: requestBody.authorizationCode,
            identityToken: requestBody.identityToken,
            userName: requestBody.userFullName
        )
        
        return self.apiService.requestAndDecodeRx(apiTarget: appleLoginAPI, retryHandler: retryHandler)
            .asObservable()
    }
    
    func reqeustKakaoLogin(requestBody: KakaoLoginReqeustBody, retryHandler: (() -> Void)? = nil) -> Observable<LoginResponseModel> {
        let kakaoLoginAPI = UserAPI.kakaoLogin(
            accessToken: requestBody.accessToken,
            refreshToken: requestBody.refreshToken,
            refreshTokenExpiresIn: requestBody.refreshExpiresIn,
            scope: requestBody.scope
        )
        
        return self.apiService.requestAndDecodeRx(apiTarget: kakaoLoginAPI, retryHandler: retryHandler)
            .asObservable()
    }
    
    private let apiService: APIService
    
}
