//
//  HabitWritingViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

import Alamofire
import RxSwift

final class HabitWritingViewModel: NSObject, DailyHabitViewModelable {
    private let session: Alamofire.Session
    private var dailyHabitModel: DailyHabitResponseModel
    private var photoImage: UIImage?
    private let habitId: Int
    private let dailyHabitOrder: Int
    var selectedStampIndex: Int = 0 {
        didSet {
            self.dailyHabitModel.stampType = self.selectStampModels[safe: self.selectedStampIndex]?.stamp.description
        }
    }

    init(habitId: Int,
         dailyHabitOrder: Int,
         session: Alamofire.Session
    ) {
        self.dailyHabitModel = DailyHabitResponseModel(
            habitId: habitId,
            status: "SUCCESS",
            createDateTime: Date().convertString(format: DailyHabitResponseModel.dateFormat))
        
        self.habitId = habitId
        self.dailyHabitOrder = dailyHabitOrder
        self.session = session
        super.init()
        
        self.updateSelectStampModels()
    }
    
    func postDailyHabit(completionHandler: @escaping (DailyHabitResponseModel) -> Void,
                        failureHandler: @escaping () -> Void) {
        let headers = HTTPHeaders([HTTPHeader(name: NetworkInfomation.HeaderKey.authorization,
                                              value: NetworkInfomation.HeaderValue.authorization)])
        self.session.upload(multipartFormData: { [weak self] multipartFormData in
            guard let self = self else { return }
            let dateData = self.dailyHabitModel.createDateTime.data(using: .utf8) ?? Data()
            let statusData = self.dailyHabitModel.status.data(using: .utf8) ?? Data()
            let contentData = self.dailyHabitModel.content?.data(using: .utf8) ?? Data()
            let stampData = self.dailyHabitModel.stampType?.data(using: .utf8) ?? Data()
            let imageData = self.photoImage?.jpegData(compressionQuality: 0.1) ?? Data()
            
            multipartFormData.append(dateData, withName: "createDateTime")
            multipartFormData.append(statusData, withName: "status")
            multipartFormData.append(contentData, withName: "content")
            multipartFormData.append(stampData, withName: "stampType")
            multipartFormData.append(
                imageData,
                withName: "image",
                fileName: "\(self.habitId)_\(self.dailyHabitOrder).jpg",
                mimeType: "image/jpeg"
            )
        }, to: "\(ServerHost.main)/api/habit/\(self.habitId)/history", headers: headers)
        .responseDecodable(of: DailyHabitResponseModel.self) { response in
            switch response.result {
                case .success(let dailyHabitResponseModel):
                    completionHandler(dailyHabitResponseModel)
                case .failure(_):
                    failureHandler()
            }
        }
    }
    
    var titleText: String {
        "\(self.dailyHabitOrder)일차"
    }
    
    func update(photoImage: UIImage?, contentText: String) {
        self.photoImage = photoImage
        self.dailyHabitModel.content = contentText
    }
    
    private var selectStampModels: [SelectStampModel] = Stamp.allCases.enumerated().map { n, stamp in
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
        if self.dailyHabitOrder > 22 {
            self.selectStampModels.enumerated().forEach { n, model in
                guard model.lockedDays == 22 else { return }
                self.selectStampModels[n].isLocked = false
            }
        }
        
        if self.dailyHabitOrder > 44 {
            self.selectStampModels.enumerated().forEach { n, model in
                guard model.lockedDays == 44 else { return }
                self.selectStampModels[n].isLocked = false
            }
        }
    }
    
    func isLocked(at index: Int) -> Bool {
        return self.selectStampModels[safe: index] != nil && self.selectStampModels[safe: index]!.isLocked
    }
    
    func openImageOfLocked(at index: Int) -> UIImage? {
        guard let selectStampModel = self.selectStampModels[safe: self.selectedStampIndex] else { return nil }
        
        return selectStampModel.stamp.defaultImage
    }
    
    func lockMessage(at index: Int) -> NSAttributedString? {
        guard let selectStampModel = self.selectStampModels[safe: self.selectedStampIndex] else { return nil }
        
        let attributedText = NSMutableAttributedString(string: "습관 \(selectStampModel.lockedDays ?? 22)일을 달성하면\n사용할 수 있어요!")
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.red_default,
                                    range: attributedText.mutableString.range(of: "\(selectStampModel.lockedDays ?? 22)일"))
        return attributedText
    }
    
    var contentText: String? {
        self.dailyHabitModel.content
    }
    
    var dateText: String? {
        self.dailyHabitModel
            .createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "yyyy-MM-dd")
    }
    
    var timeText: String? {
        self.dailyHabitModel
            .createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "h:mm a", amSymbol: "AM", pmSymbol: "PM")
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
