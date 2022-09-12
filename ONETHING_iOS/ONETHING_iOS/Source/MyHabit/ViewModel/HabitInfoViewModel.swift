//
//  CardViewModel.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import Foundation
import UIKit

struct HabitInfoViewModel {
    var presentable: MyHabitCellPresentable?
    
    var titleText: String? {
        return self.presentable?.title
    }
    
    var resultText: String {
        guard let habitStatus = self.presentable?.onethingHabitStatus
        else { return "성공" }
        
        let isSuccess = habitStatus == .success
        return isSuccess ? "성공" : "실패"
    }
    
    var resultLabelColor: UIColor {
        guard let habitStatus = self.presentable?.onethingHabitStatus
        else { return .red_default }
        
        let isSuccess = habitStatus == .success
        return isSuccess ? .red_default : .mint_2
    }
    
    var resultDesciptionText: String? {
        guard let progressDuration = self.presentable?.progressDuration
        else { return nil }
        
        guard let successPercent = self.presentable?.successPercent
        else { return nil }
        
        return "\(progressDuration) • 습관 성공률 \(successPercent)%"
    }
}
