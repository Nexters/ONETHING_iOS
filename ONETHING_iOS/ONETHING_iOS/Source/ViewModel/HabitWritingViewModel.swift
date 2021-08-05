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
    private(set) var photoImage: UIImage?
    private(set) var content: String?
    private(set) var stampType: String?
    var habitId: Int?
    var dailyHabitOrder: Int? {
        didSet { self.updateSelectStampModels() }
    }

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
    
    var selectStampModels: [SelectStampModel] = Stamp.allCases.enumerated().map { n, stamp in
        let openStampFirstIndex = 0
        let openStampLastIndex = 3
        let lockedStampLastIndex = 7
        
        if n >= openStampFirstIndex && n <= openStampLastIndex {
            return SelectStampModel(isLocked: false, lockedDays: nil, stamp: stamp)
        } else if n <= lockedStampLastIndex {
            return SelectStampModel(isLocked: true, lockedDays: 22, stamp: stamp)
        } else {
            return SelectStampModel(isLocked: true, lockedDays: 44, stamp: stamp)
        }
    }
    
    func updateSelectStampModels() {
        guard let dailyHabitOrder = self.dailyHabitOrder else { return }
        
        if dailyHabitOrder > 22 {
            self.selectStampModels.enumerated().forEach { n, model in
                guard model.lockedDays == 22 else { return }
                self.selectStampModels[n].isLocked = false
            }
        }
        
        if dailyHabitOrder > 44 {
            self.selectStampModels.enumerated().forEach { n, model in
                guard model.lockedDays == 44 else { return }
                self.selectStampModels[n].isLocked = false
            }
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
        
        if indexPath.item == 0 {
            guard let habitStampView = collectionView as? HabitStampView else { return habitStampCell }
            habitStampView.prevCheckedCell = habitStampCell
            habitStampCell.showCheckView()
        }
        
        if let selectStampModel = self.selectStampModels[safe: indexPath.row] {
            habitStampCell.update(with: selectStampModel)
        }

        return habitStampCell
    }
}
