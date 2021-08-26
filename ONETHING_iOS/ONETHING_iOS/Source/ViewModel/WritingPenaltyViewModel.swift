//
//  WritingPenaltyViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/26.
//

import Foundation

import RxSwift

final class WritingPenaltyViewModel: PenaltyInfoViewModable {
    private let habitID: Int
    private(set) var sentence: String
    private(set) var penaltyCount: Int
    private let apiService: APIService
        
    init(habitID: Int, sentence: String,
         penaltyCount: Int, apiService: APIService = APIService()) {
        self.habitID = habitID
        self.sentence = sentence
        self.penaltyCount = penaltyCount
        self.apiService = apiService
    }
    
    func putDelayPenaltyForCompleted(completion: @escaping (Bool) -> Void) {
        let writePenaltyAPI: ContentAPI = .putPassDelayPenalty(habitId: self.habitID)
        self.apiService.requestAndDecodeRx(apiTarget: writePenaltyAPI)
            .subscribe(onSuccess: { (result: Bool) in
                completion(result)
            }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    var penaltyWriteCountText: String {
        return "\(self.penaltyCount)번"
    }
}
