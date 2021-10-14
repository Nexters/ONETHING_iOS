//
//  SuccessPopupViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/10/14.
//

import Foundation
import RxSwift

final class SuccessPopupViewModel {
    private let habitResponseModel: HabitResponseModel
    
    init(habitResponseModel: HabitResponseModel) {
        self.habitResponseModel = habitResponseModel
    }
    
    var titleText: String {
        return self.habitResponseModel.title
    }
    
    var progressText: String? {
        guard let startDate = self.textOfStartDate,
              let endDate = self.textOfEndDate
        else { return nil }
        
        return "\(startDate) - \(endDate)"
    }
    
    private var textOfStartDate: String? {
        let date = self.habitResponseModel.startDate.convertToDate(format: "yyyy-MM-dd")
        return date?.convertString(format: "yyyy.MM.dd")
    }
    
    private var textOfEndDate: String? {
        guard let date = self.habitResponseModel.startDate.convertToDate(format: "yyyy-MM-dd")
              else { return nil}
        
        let days = DateComponents(day: HomeViewModel.defaultTotalDays - 1)
        let endDate = Calendar.current.date(byAdding: days, to: date)
        return endDate?.convertString(format: "yyyy.MM.dd")
    }
    
    var percentText: String {
        let percent: Double = Double(self.habitResponseModel.successCount) / Double(HomeViewModel.defaultTotalDays)
        return String(format: "%.1f%", percent)
    }
}
