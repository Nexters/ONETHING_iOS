//
//  UserRepository.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/02/27.
//

import RxSwift
import Foundation

protocol UserRepository {
    func requestAppleLogin(requestBody: AppleLoginRequestBody, retryHandler: (() -> Void)?) -> Observable<LoginResponseModel>
    func reqeustKakaoLogin(requestBody: KakaoLoginReqeustBody, retryHandler: (() -> Void)?) -> Observable<LoginResponseModel>
    func requestLogout(retryHandler: (() -> Void)?) -> Observable<Bool>
    func requestWithdrawl() -> Observable<Bool>
}

final class UserRepositoryImpl: UserRepository {
    
    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    func requestLogout(retryHandler: (() -> Void)? = nil) -> Observable<Bool> {
        guard let accessToken = OnethingUserManager.sharedInstance.accessToken   else { return Observable.just(false) }
        guard let refreshToken = OnethingUserManager.sharedInstance.refreshToken else { return Observable.just(false) }
        
        let logoutAPI = UserAPI.logout(accessToken: accessToken, refreshToken: refreshToken)
        return self.apiService.requestRx(apiTarget: logoutAPI, retryHandler: retryHandler)
            .asObservable()
            .map { response in
                if response.statusCode == 200 {
                    return true
                } else {
                    return false
                }
            }
    }
    
    func requestWithdrawl() -> Observable<Bool> {
        guard let accessToken = OnethingUserManager.sharedInstance.accessToken   else { return Observable.just(false) }
        guard let refreshToken = OnethingUserManager.sharedInstance.refreshToken else { return Observable.just(false) }
        
        let withdrwalAPI = UserAPI.withdrawl(accessToken: accessToken, refreshToken: refreshToken)
        return self.apiService.requestRx(apiTarget: withdrwalAPI, retryHandler: nil)
            .asObservable()
            .map { response in
                if response.statusCode == 200 {
                    return true
                } else {
                    return false
                }
            }
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
    
    private let apiService: APIServiceType
    private let disposeBag = DisposeBag()
    
}
