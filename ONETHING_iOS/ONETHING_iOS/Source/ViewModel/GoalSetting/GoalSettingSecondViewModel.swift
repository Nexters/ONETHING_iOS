//
//  GoalSetttingSecondViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/17.
//

import Foundation
import RxSwift

final class GoalSettingSecondViewModel {
    
    static let maxInputCount: Int = 20
    
    let enableNextSubject = PublishSubject<Bool>()
    
    func checkProccessable(_ text: String) {
        let proccessable = text.count > 0 && text.count <= type(of: self).maxInputCount
        self.enableNextSubject.onNext(proccessable)
    }
    
    private let disposeBag = DisposeBag()
    
}
