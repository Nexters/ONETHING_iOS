//
//  WritingPenaltyViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/26.
//

import Foundation

import RxSwift

final class WritingPenaltyViewModel: PenaltyInfoViewModable {
    enum Notification {
        static let userInputTextDidChange = Foundation.Notification.Name("userInputTextDidChange")
    }
    
    private let habitID: Int
    private(set) var sentence: String
    private(set) var penaltyCount: Int
    private let apiService: APIServiceType
    private var userInputTextsForPenalty: [String] {
        didSet {
            self.notifyUserInputTextDidChange(with: oldValue)
        }
    }
        
    init(
        habitID: Int,
        sentence: String,
        penaltyCount: Int,
        apiService: APIServiceType = APIService.shared
    ) {
        self.habitID = habitID
        self.sentence = sentence
        self.penaltyCount = penaltyCount
        self.userInputTextsForPenalty = (0..<penaltyCount).map { _ in return "" }
        self.apiService = apiService
    }
    
    func putDelayPenaltyForCompleted(completion: @escaping (Bool) -> Void) {
        let writePenaltyAPI: ContentAPI = .putPassDelayPenalty(habitId: self.habitID)

        self.apiService.requestRx(apiTarget: writePenaltyAPI, retryHandler: nil)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                let isComplete = response.statusCode == 200 ? true : false
                completion(isComplete)
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateUserInputText(at index: Int, _ inputText: String?) {
        guard let inputText = inputText
        else { return }
        
        guard self.userInputTextsForPenalty[safe: index] != nil
        else { return }
        
        self.userInputTextsForPenalty[index] = inputText.trimmingLeadingAndTrailingSpaces()
    }
    
    private func notifyUserInputTextDidChange(with oldValue: [String]) {
        guard let changedModel: (index: Int, text: String?) = self.changedModel(with: oldValue)
        else { return }
        
        NotificationCenter.default.post(
            name: Self.Notification.userInputTextDidChange,
            object: nil,
            userInfo: [
                "targetIndex": changedModel.index,
                "updatedText": changedModel.text as Any
            ]
        )
    }
    
    private func changedModel(with oldValue: [String]) -> (Int, String?)? {
        var targetIndex: Int = 0
        var targetText: String?
        var currentIndex = 0
        for (lhs, rhs) in zip(oldValue, self.userInputTextsForPenalty) {
            if lhs != rhs {
                targetIndex = currentIndex
                targetText = self.userInputTextsForPenalty[safe: currentIndex]
                return (targetIndex, targetText)
            }
            
            currentIndex += 1
        }
        return nil
    }
    
    private let disposeBag = DisposeBag()
    
    var penaltyWriteCountText: String {
        return "\(self.penaltyCount)번"
    }
    
    func isValid(at index: Int) -> Bool {
        guard let userInputText = self.userInputTextsForPenalty[safe: index]
        else { return false }
        
        return self.sentence == userInputText
    }
    
    var allValid: Bool {
        for userInputText in self.userInputTextsForPenalty {
            if self.sentence != userInputText {
                return false
            }
        }
        return true
    }
}
