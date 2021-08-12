//
//  HabitWrittenViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

import Moya
import RxSwift
import Kingfisher

final class HabitWrittenViewModel: DailyHabitViewModelable {
    private let dailyHabitModel: DailyHabitResponseModel
    private let imageUseCase = HabitImageUseCase()
    private let imageCache: Kingfisher.ImageCache
    
    init(dailyHabitModel: DailyHabitResponseModel,
         imageCache: Kingfisher.ImageCache = Kingfisher.ImageCache.default) {
        self.dailyHabitModel = dailyHabitModel
        self.imageCache = imageCache
    }
    
    func requestHabitImageRx() -> Observable<Image> {
        return Observable.create { [weak self] emitter in
            guard let self = self,
                  let createDate: String = self.dailyHabitModel.createDateTime
                    .convertToDate(format: DailyHabitResponseModel.dateFormat)?
                    .convertString(format: "yyyy-MM-dd") else { return Disposables.create() }
            
            self.imageUseCase.requestHabitImage(
                createDate: createDate,
                imageExtension: self.dailyHabitModel.imageExtension ?? "jpg") { (photoImage: UIImage) in
                    emitter.onNext(photoImage)
            }
            
            return Disposables.create()
        }
    }
    
    var currentStampImage: UIImage? {
        self.dailyHabitModel.castringStamp?.defaultImage
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
