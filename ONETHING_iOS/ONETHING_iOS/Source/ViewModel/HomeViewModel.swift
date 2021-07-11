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
        return 66
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell = collectionView.dequeueReusableCell(
                cell: HabitCalendarCell.self,
                forIndexPath: indexPath
        ) else { return HabitCalendarCell() }
        
        habitCalendarCell.configure(numberText: "\(indexPath.row + 1)일")
        return habitCalendarCell
    }
}
