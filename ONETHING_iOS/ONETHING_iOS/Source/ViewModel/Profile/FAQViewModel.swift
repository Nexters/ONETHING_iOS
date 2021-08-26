//
//  FAQViewModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import Foundation
import RxSwift
import RxRelay

final class FAQViewModel {
    
    let faqRelay = BehaviorRelay<[NoticeModel]>(value: [])
    
    func requestFAQ() {
        let faqAPI = ContentAPI.getQuestions
        
        APIService.shared.requestAndDecodeRx(apiTarget: faqAPI, retryHandler: { [weak self] in
            self?.requestFAQ()
        }).subscribe(onSuccess: { [weak self] (faqListModel: [NoticeModel]) in
            self?.faqRelay.accept(faqListModel)
        }).disposed(by: self.disposeBag)
    }
    
    func updateExpandingStatus(of faqModel: NoticeModel, expanding: Bool) {
        guard let id = faqModel.id else { return }
        
        if expanding { self.expandingSet.insert(id) }
        else         { self.expandingSet.remove(id) }
    }
    
    private(set) var expandingSet: Set<Int> = []
    private let disposeBag = DisposeBag()
    
}
