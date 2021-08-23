//
//  ProfileSettingViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/22.
//

import RxSwift
import RxRelay
import Foundation

final class ProfileSettingViewModel {
    
    let selectedProfileRelay = BehaviorRelay<OnethingProfileType>(value: .study)
    let nicknameRelay = BehaviorRelay<String>(value: "")
    let completeSubject = PublishSubject<Void>()
    
    func updateSelectedProfile(_ profile: OnethingProfileType) {
        self.selectedProfileRelay.accept(profile)
    }
    
    func updateNickname(_ nickname: String) {
        self.nicknameRelay.accept(nickname)
    }
    
    func requestSetProfile() {
        guard self.requesting == false else { return }
        
        let nickname = self.nicknameRelay.value
        let profile = self.selectedProfileRelay.value.rawValue
        
        let profileAPI = UserAPI.setProfile(nickname: nickname, imageType: profile)
        
        self.requesting = true
        APIService.shared.requestAndDecodeRx(apiTarget: profileAPI, retryHandler: { [weak self] in
            self?.requestSetProfile()
        }).subscribe(onSuccess: { [weak self] (userModel: OnethingUserModel) in
            OnethingUserManager.sharedInstance.updateUser(userModel)
            self?.completeSubject.onNext(())
            self?.requesting = false
        }, onFailure: { [weak self] _ in
            self?.requesting = false
        }).disposed(by: self.disposeBag)
    }
    
    private var requesting: Bool = false
    private let disposeBag = DisposeBag()
    
}
