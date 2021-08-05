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
    var habitId: Int?
    var dailyHabitOrder: Int?
    private(set) var photoImage: UIImage?
    private(set) var content: String?
    private(set) var stampType: String?

    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
    }
    
    func postDailyHabit() {
        guard let habitId = self.habitId,
              let dailyHabitOrder = self.dailyHabitOrder,
              let content = self.content,
              let stickerId = self.stampType,
              let image = self.photoImage else { return }
        
        let dailyHabitAPI: ContentAPI = .createDailyHabit(
            habitId: habitId,
            dailyHabitOrder: dailyHabitOrder,
            date: Date().convertString(format: "yyyy-MM-dd"),
            status: "SUCCESS",
            content: content,
            stickerId: stickerId,
            image: image)
        
        self.apiService.requestAndDecode(api: dailyHabitAPI) { (dailyHabit: DailyHabitResponseModel) in
            
        }
    }
    
    var titleText: String? {
        "\(self.dailyHabitOrder ?? 0)일차"
    }
    
    func update(photoImage: UIImage? = nil, content: String? = nil, stampType: String?) {
        self.photoImage = photoImage
        self.content = content
        self.stampType = stampType
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
