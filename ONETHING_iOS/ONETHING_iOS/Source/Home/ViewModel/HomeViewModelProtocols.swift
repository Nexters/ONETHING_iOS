//
//  HomeViewModelProtocols.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/07.
//

import UIKit

protocol GiveUpWarningPopupViewPresentable: AnyObject {
    var habitInProgressModel: HabitResponseModel? { get }
    
    var currentDayText: String? { get }
    var diffDaysFromStartToCurrent: Int? { get }
    var subTitleTextOfGiveupWarningPopupView: NSAttributedString? { get }
}

extension GiveUpWarningPopupViewPresentable {
    var currentDayText: String? {
        guard let diffDays = self.diffDaysFromStartToCurrent else { return nil }
        
        return String(diffDays + 1)
    }
    
    var diffDaysFromStartToCurrent: Int? {
        guard let habitInProgressModel = self.habitInProgressModel,
              let startDate = habitInProgressModel.startDate.convertToDate(format: "yyyy-MM-dd")
        else { return nil }
        
        let formatter = DateComponentsFormatter().then {
            $0.allowedUnits = [.day]
            $0.unitsStyle = .positional
        }
        
        guard let diffDaysStr = formatter
                .string(from: startDate, to: Date())?
                .components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined(), let diffDays = Int(diffDaysStr) else { return nil }
        
        return diffDays
    }
    
    var subTitleTextOfGiveupWarningPopupView: NSAttributedString? {
        guard let pretendardFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 15)
        else { return nil }
        
        let titleText = "열심히 달려온\n지금의 습관을\n정말로 그만하시겠어요?"
        let attributeText = NSMutableAttributedString(string: titleText,
                                                      attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100])
        return attributeText.with(lineSpacing: 4.0)
    }
}

protocol FailPopupViewPresentable: GiveUpWarningPopupViewPresentable {
    var titleTextOfFailPopupView: String? { get }
    var progressCountTextOfFailPopupView: String? { get }
    var reasonTextOfFailPopupView: String? { get }
}

extension FailPopupViewPresentable {
    var titleTextOfFailPopupView: String? {
        return "아쉽지만\n습관은 여기까지!"
    }
    
    var progressCountTextOfFailPopupView: String? {
        guard let currentDayText = self.currentDayText else {
            return nil
        }
        
        return "진행: \(currentDayText)일차"
    }
}
