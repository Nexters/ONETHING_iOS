//
//  MyHabitCellPresentable.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/06.
//

import UIKit

protocol MyHabitCellPresentable {
    var habitId: Int { get }
    var habitStatus: String { get }
    var title: String { get }
    var startDate: String { get }
    var successCount: Int { get }
    var sentenceForDelay: String { get }
}

extension MyHabitCellPresentable {
    
    var onethingHabitStatus: HabitStatus? {
        HabitStatus(rawValue: self.habitStatus)
    }
    
    var cellBackgroundImage: UIImage? {
        switch self.onethingHabitStatus {
        case .success:
            return UIImage(named: "habit_success")
        case .fail, .pass:
            return UIImage(named: "habit_failure")
        default:
            return nil
        }
    }
    
    var cellBackgroundColor: UIColor {
        switch self.onethingHabitStatus {
        case .success:
            return .black_100
        case .fail, .pass:
            return .black_60
        default:
            return .clear
        }
    }
    
    var cellBorderViewColor: UIColor {
        switch self.onethingHabitStatus {
        case .success:
            return .black_80
        case .fail, .pass:
            return .black_40
        default:
            return .clear
        }
    }
    
    var progressDuration: String {
        guard let startDate = self.startDate.convertToDate(format: "yyyy-MM-dd")                else { return "" }
        guard let endDate = Calendar.current.date(byAdding: .day, value: 66 - 1, to: startDate) else { return "" }
        
        var startDateString = startDate.convertString(format: "yyyy.MM.dd")
        var endDateString = endDate.convertString(format: "yyyy.MM.dd")
        
        startDateString.removeFirst()
        startDateString.removeFirst()
        endDateString.removeFirst()
        endDateString.removeFirst()
        
        return "\(startDateString) - \(endDateString)"
    }
    
    var successPercent: Int {
        let rate = Float(self.successCount) / 66
        let percent = rate * 100
        let roundedPercent = round(percent)
        return Int(roundedPercent)
    }
    
}
