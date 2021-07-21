//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

final class HomeViewModel: NSObject {
    
}

extension HomeViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let habitCalendarView = collectionView as? HabitCalendarView else { return HabitCalendarView.defaultTotalCellNumbers }
        return habitCalendarView.totalCellNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(
                cell: HabitCalendarCell.self,
                forIndexPath: indexPath
        ) else { return HabitCalendarCell() }
        
        habitCalendarCell.setup(numberText: "\(indexPath.row + 1)")
        
        if indexPath.item == 0 {
            habitCalendarCell.set(isWrtten: true)
            habitCalendarCell.update(stampImage: Stamp.beige.defaultImage)
            habitCalendarCell.setup(numberText: "")
        }
        
        return habitCalendarCell
    }
}
