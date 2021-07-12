//
//  HabitCalendarView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/12.
//

import UIKit

final class HabitCalendarView: UICollectionView {
    static let defaultTotalCellNumbers = 66
    let totalCellNumbers: Int
    let numberOfColumns: Int
    
    init(frame: CGRect, totalCellNumbers: Int, columnNumbers: Int) {
        self.totalCellNumbers = totalCellNumbers
        self.numberOfColumns = columnNumbers
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        self.totalCellNumbers = 0
        self.numberOfColumns = 0
        super.init(coder: coder)
    }
    
    var numberOfRows: Int {
        return Int(Double(totalCellNumbers / numberOfColumns).rounded(.up))
    }
    
    var ratioHeightPerWidth: Double {
        return Double(numberOfRows / numberOfColumns).rounded(.up) * 2
    }
}
