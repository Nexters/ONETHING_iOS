//
//  HabitCalendarView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/12.
//

import UIKit

final class HabitCollectionView: UICollectionView {
    let totalCellNumbers: Int
    let numberOfColumns: Int
    
    init(frame: CGRect = .zero, totalCellNumbers: Int, columnNumbers: Int) {
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
        return Int((Double(self.totalCellNumbers) / Double(self.numberOfColumns)).rounded(.up))
    }
    
    var topConstant: CGFloat {
        return 30
    }
    
    var bottomConstant: CGFloat {
        return 30
    }
    
    var leadingConstant: CGFloat {
        return 32
    }
    
    var trailingConstant: CGFloat {
        return 32
    }

    var innerContant: CGFloat {
        return 20
    }
    
    func cellDiameter(superViewWidth: CGFloat) -> CGFloat {
        let fullLengthForRow: CGFloat = superViewWidth - leadingConstant * 2 - CGFloat(self.numberOfColumns - 1) * self.innerContant
        let cellNumsForRow = CGFloat(self.numberOfColumns)
        return fullLengthForRow / cellNumsForRow
    }
}
