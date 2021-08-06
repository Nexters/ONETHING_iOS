//
//  HabitWritingViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

import Alamofire

final class HabitWritingViewModel: NSObject {
    private let apiService: Alamofire.Session
    private(set) var photoImage: UIImage?
    private(set) var content: String?
    var habitId: Int?
    var dailyHabitOrder: Int? {
        didSet { self.updateSelectStampModels() }
    }
    var selectedStampIndex: Int = 0
    var stampType: String? {
        self.selectStampModels[safe: self.selectedStampIndex]?.stamp.description
    }

    init(apiService: Alamofire.Session = AF) {
        self.apiService = apiService
    }
    
    func postDailyHabit() {
        guard let habitId = self.habitId,
              let dailyHabitOrder = self.dailyHabitOrder,
              let content = self.content,
              let stampType = self.stampType,
              let image = self.photoImage else { return }
        
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: NetworkInfomation.Request.HeaderValues.authorization)])
        AF.upload(multipartFormData: { multipartFormData in
            let dateData = Date().convertString(format: "yyyy-MM-dd'T'HH:mm:ss").data(using: .utf8) ?? Data()
            let statusData = "SUCCESS".data(using: .utf8) ?? Data()
            let contentData = content.data(using: .utf8) ?? Data()
            let stampData = stampType.data(using: .utf8) ?? Data()
            let imageData = image.jpegData(compressionQuality: 0.1) ?? Data()

            multipartFormData.append(dateData, withName: "createDateTime")
            multipartFormData.append(statusData, withName: "status")
            multipartFormData.append(contentData, withName: "content")
            multipartFormData.append(stampData, withName: "stampType")
            multipartFormData.append(imageData, withName: "image", fileName: "\(habitId)_\(dailyHabitOrder).jpg", mimeType: "image/jpeg")
        }, to: "http://49.50.174.147:8080/api/habit/\(habitId)/history", headers: headers)
        .responseDecodable(of: DailyHabitResponseModel.self) { response in
            print(String(data: response.data!, encoding: .utf8)!)
        }
    }
    
    var titleText: String? {
        "\(self.dailyHabitOrder ?? 0)일차"
    }
    
    func update(photoImage: UIImage? = nil, content: String? = nil) {
        self.photoImage = photoImage
        self.content = content
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
