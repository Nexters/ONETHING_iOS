//
//  AnnounceViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import Foundation
import RxSwift
import RxRelay

final class NoticeViewModel {
    
    #warning("일단 임시로 데이터 타입 몰라서 지정")
    let noticesRelay = BehaviorRelay<[String]>(value: ["awdadw", "awdawd"])
    
    func requestNoticeModel() {
        
    }
    
    private let disposeBag = DisposeBag()
    
}
