//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

class HomeViewModel: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 66
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCalendarCell =  collectionView.dequeueReusableCell(withReuseIdentifier: HabitCalendarCell.reuseIdentifier, for: indexPath) as? HabitCalendarCell else { return HabitCalendarCell() }
        
        habitCalendarCell.configure(numberText: "\(indexPath.row + 1)일")
        
        return habitCalendarCell
    }
}
