//
//  HabitWritingViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

final class HabitWritingViewModel: NSObject {
    
}

extension HabitWritingViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCell = collectionView.dequeueReusableCell(
                cell: HabitCalendarCell.self, forIndexPath: indexPath
        ) else { return HabitCalendarCell() }
        
        return habitCell
    }
}
