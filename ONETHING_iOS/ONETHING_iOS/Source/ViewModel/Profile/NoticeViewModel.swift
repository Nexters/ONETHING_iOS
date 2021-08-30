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
    
    let noticesRelay = BehaviorRelay<[NoticeModel]>(value: [])
    
    func requestNoticeModel() {
        let noticeAPI = ContentAPI.getNotices
        
        APIService.shared.requestAndDecodeRx(apiTarget: noticeAPI, retryHandler: { [weak self] in
            self?.requestNoticeModel()
        }).subscribe(onSuccess: { [weak self] (noticeListModel: [NoticeModel]) in
            self?.noticesRelay.accept(noticeListModel)
        }).disposed(by: self.disposeBag)
    }
    
    func updateExpandingStatus(of model: NoticeModel, isExpanding: Bool) {
        guard let id = model.id else { return }
        
        if isExpanding { self.expandingSet.insert(id) }
        else           { self.expandingSet.remove(id) }
    }
    
    private(set) var expandingSet: Set<Int> = []
    private let disposeBag = DisposeBag()
    
}
