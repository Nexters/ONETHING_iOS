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
    
}
