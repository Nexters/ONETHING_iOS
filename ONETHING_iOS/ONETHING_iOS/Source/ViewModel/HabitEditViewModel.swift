//
//  HabitEditViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/26.
//

import UIKit

import RxSwift

final class HabitEditViewModel: PenaltyInfoViewModable {
    private(set) var habitInProgressModel: HabitResponseModel
    private let colors: [OnethingColor] = [.black_100, .red, .yellow_2, .mint_2, .blue, .purple_2]
    
    private let apiService: APIService
    private let disposeBag = DisposeBag()
    
    init(habitInProgressModel: HabitResponseModel, apiService: APIService = APIService()) {
        self.habitInProgressModel = habitInProgressModel
        self.apiService = apiService
    }
    
    func putEditHabit(completionHandler: @escaping (HabitResponseModel) -> Void, failureHandler: @escaping () -> Void) {
        let habitInProgressModel = self.habitInProgressModel
        guard let pushTime = habitInProgressModel.pushTime else { return }
        
        let editHabitAPI: ContentAPI = .editHabit(
            habitId: habitInProgressModel.habitId,
            color: habitInProgressModel.color,
            pushTime: pushTime,
            penaltyCount: habitInProgressModel.penaltyCount
        )
        
        self.apiService.requestAndDecodeRx(apiTarget: editHabitAPI)
            .subscribe(onSuccess: { (responseModel: HabitResponseModel) in
                self.habitInProgressModel = responseModel
                completionHandler(responseModel)
            }, onFailure: { _ in
                failureHandler()
            }).disposed(by: self.disposeBag)
    }
    
    func update(penaltyCount: Int) {
        self.habitInProgressModel.penaltyCount = penaltyCount
    }
    
    func updateColor(with index: Int) {
        guard let onethingColor = self.colors[safe: index] else { return }

        self.habitInProgressModel.color = onethingColor.rawValue
    }
    
    var currentColorIndex: Int {
        return self.index(of: OnethingColor(rawValue: self.habitInProgressModel.color) ?? .black_100)
    }
    
    private func index(of color: OnethingColor) -> Int {
        return self.colors.firstIndex(of: color) ?? 0
    }
    
    func color(at index: Int) -> UIColor? {
        return self.colors[safe: index]?.color
    }
    
    func delayImage(at index: Int) -> UIImage? {
        let delayCount = self.habitInProgressModel.delayCount
        if index < delayCount {
            return UIImage(named: "delay_use")
        } else {
            return UIImage(named: "delay_info")
        }
    }
    
    var delayRemainedText: String? {
        let delayMaxCount = self.habitInProgressModel.delayMaxCount
        let delayCount = self.habitInProgressModel.delayCount
        
        return "\(abs(delayMaxCount - delayCount))번 남았어요!"
    }
    
    var penaltyWriteCountText: String {
        let penaltyCount = self.habitInProgressModel.penaltyCount
        return "\(penaltyCount)번"
    }
  
    var penaltySentence: String {
        return self.habitInProgressModel.sentence
    }
    
    var pushTimeText: String? {
        self.habitInProgressModel.pushTime?
            .convertToDate()?
            .convertString(format: "a h'시' mm'분'", amSymbol: "오전", pmSymbol: "오후")
    }
}
