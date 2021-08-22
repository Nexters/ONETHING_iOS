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
    let noticesRelay = BehaviorRelay<[NoticeModel]>(value: [])
    
    func requestNoticeModel() {
        let noticeAPI = ContentAPI.getNotices
        
        APIService.shared.requestAndDecodeRx(apiTarget: noticeAPI, retryHandler: { [weak self] in
            self?.requestNoticeModel()
        }).subscribe(onSuccess: { (noticeListModel: [NoticeModel]) in
            self.noticesRelay.accept(noticeListModel)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
}
