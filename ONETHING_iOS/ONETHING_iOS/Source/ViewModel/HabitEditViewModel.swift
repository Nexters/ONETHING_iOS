//
//  HabitEditViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/26.
//

import UIKit

final class HabitEditViewModel {
    private(set) var habitInProgressModel: HabitResponseModel
    private let colors: [OnethingColor] = [.black_100, .red, .yellow_2, .mint_2, .blue, .purple_2]
    
    init(habitInProgressModel: HabitResponseModel) {
        self.habitInProgressModel = habitInProgressModel
    }
    
    func update(penaltyCount: Int) {
        self.habitInProgressModel.penaltyCount = penaltyCount
    }
    
    func updateColor(with index: Int) {
        guard let onethingColor = self.colors[safe: index] else { return }

        self.habitInProgressModel.color = onethingColor.rawValue
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
    
    var pushTimeText: String? {
        self.habitInProgressModel.pushTime?
            .convertToDate()?
            .convertString(format: "a h'시' mm'분'", amSymbol: "오전", pmSymbol: "오후")
    }
}
