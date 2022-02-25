//
//  AccountViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import Foundation
import RxSwift
import RxRelay

final class AccountViewModel {
    
    let logoutSuccessSubject = PublishSubject<Void>()
    let loadingSubject = PublishSubject<Bool>()
    let userRelay = BehaviorRelay<OnethingUserModel?>(value: nil)

    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }
    
    func requestUserInform() {
        self.loadingSubject.onNext(true)
        
        OnethingUserManager.sharedInstance.requestAccount { [weak self] user in
            guard let userModel = user.account else { return }
            self?.userRelay.accept(userModel)
            self?.loadingSubject.onNext(false)
        }
    }
    
    func requestLogout() {
        self.loadingSubject.onNext(true)
        self.userRepository.requestLogout(
            retryHandler: { [weak self] in
                self?.requestLogout()
            })
            .withUnretained(self)
            .subscribe(onNext: { owner, isSuccess in
                owner.loadingSubject.onNext(false)

                guard isSuccess == true else { return }
                OnethingUserManager.sharedInstance.clearUserInform()
                owner.logoutSuccessSubject.onNext(())
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func requestWithdrawl() {
        self.loadingSubject.onNext(true)
        self.userRepository.requestWithdrawl()
            .withUnretained(self)
            .subscribe(onNext: { owner, isSuccess in
                owner.loadingSubject.onNext(false)
                
                guard isSuccess == true else { return }
                OnethingUserManager.sharedInstance.clearUserInform()
                owner.logoutSuccessSubject.onNext(())
            }, onError: { [weak self] _ in
                self?.loadingSubject.onNext(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
}
