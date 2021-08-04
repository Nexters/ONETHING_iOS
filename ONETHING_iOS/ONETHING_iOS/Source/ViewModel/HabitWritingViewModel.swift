//
//  HabitWritingViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

import Moya

final class HabitWritingViewModel: NSObject {
    private let apiService: APIService<ContentAPI>

    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func postDailyHabit() {
        self.apiService.requestAndDecode(api: .createDailyHabit(habitId: 1, date: Date().toString(), status: "SUCCESS", content: "", stickerId: "red", image: NSData())) { (dailyHabit: DailyHabitResponseModel) in
            
        }
    }
}

extension HabitWritingViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitStampView.defaultTotalCellNumbers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitStampCell = collectionView.dequeueReusableCell(
                cell: HabitStampCell.self, forIndexPath: indexPath
        ) else { return HabitStampCell() }
        
        let openFirstIndex = 0
        let openLastIndex = 3
        
        if indexPath.item == openFirstIndex {
            guard let habitStampView = collectionView as? HabitStampView else { return HabitStampCell() }
            habitStampView.prevCheckedCell = habitStampCell
            habitStampCell.showCheckView()
        }
        
        guard let stamp = Stamp.allCases[safe: indexPath.item] else { return HabitStampCell() }
        
        if indexPath.item >= openFirstIndex && indexPath.item <= openLastIndex {
            habitStampCell.update(stamp: stamp, isLocked: false)
        } else  {
            habitStampCell.update(stamp: stamp, isLocked: true)
        }
        
        return habitStampCell
    }
}
