//
//  ObservableType+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func observeOnMain() -> Observable<Element> {
        return self.observe(on: MainScheduler.instance)
    }
    
}
