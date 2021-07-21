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
        return HabitStampView.defaultTotalCellNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitStampCell = collectionView.dequeueReusableCell(
                cell: HabitStampCell.self, forIndexPath: indexPath
        ) else { return HabitStampCell() }
        guard let stampImage = HabitStampView.Stamp.allCases[safe: indexPath.item]?.image else { return HabitStampCell() }
        habitStampCell.update(stampImage: stampImage)
        
        return habitStampCell
    }
}
