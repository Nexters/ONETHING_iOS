//
//  ObservableType+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func observeOnMain(onNext: @escaping (Self.Element) -> Swift.Void) -> Disposable {
        return self.observe(on: MainScheduler.instance).subscribe(onNext: onNext)
    }
    
}
