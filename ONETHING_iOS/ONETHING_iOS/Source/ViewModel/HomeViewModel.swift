//
//  HomeViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/11.
//

import UIKit

import Moya

final class HomeViewModel: NSObject {
    private let apiService: APIService<ContentAPI>
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func requestHabitInProgress() {
        self.apiService.requestAndDecode(api: .getHabitInProgress) { [weak self] (habitResponseModel: HabitResponseModel) in
            
        }
    }
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
        
        if let stampImage = Stamp.allCases[safe: indexPath.item]?.defaultImage {
            habitCalendarCell.set(isWrtten: true)
            habitCalendarCell.update(stampImage: stampImage)
            habitCalendarCell.setup(numberText: "")
        }
        
        return habitCalendarCell
    }
}
