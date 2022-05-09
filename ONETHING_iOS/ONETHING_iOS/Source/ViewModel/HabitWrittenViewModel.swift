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
    private let dailyHabitModel: DailyHabitModel
    private let imageUseCase = HabitImageUseCase()
    private let imageCache: Kingfisher.ImageCache
    
    init(dailyHabitModel: DailyHabitModel,
         imageCache: Kingfisher.ImageCache = Kingfisher.ImageCache.default) {
        self.dailyHabitModel = dailyHabitModel
        self.imageCache = imageCache
    }
    
    func requestHabitImageRx() -> Observable<Image> {
        return Observable.create { [weak self] emitter in
            guard let self = self,
                  let createDate: String = self.dailyHabitModel.responseModel.createDateTime
                    .convertToDate(format: DailyHabitResponseModel.dateFormat)?
                    .convertString(format: "yyyy-MM-dd") else { return Disposables.create() }
            
            guard let imageExtension = self.dailyHabitModel.responseModel.imageExtension else { return Disposables.create() }
            
            self.imageUseCase.requestHabitImage(
                createDate: createDate,
                imageExtension: imageExtension) { (photoImage: UIImage) in
                    emitter.onNext(photoImage)
                }
            
            return Disposables.create()
        }
    }
    
    var currentStampImage: UIImage? {
        self.dailyHabitModel.responseModel.castingStamp?.defaultImage
    }
    
    var dayText: String {
        "\(self.dailyHabitModel.order)일차"
    }
    
    var statusText: String? {
        guard let status = self.dailyHabitModel.responseModel.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return "성공"
            case .delayPenalty:
                fallthrough
            case .delay:
                return "미룸"
        }
    }
    
    var statusColor: UIColor? {
        guard let status = self.dailyHabitModel.responseModel.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return .red_default
            case .delayPenalty:
                fallthrough
            case .delay:
                return .mint_2
        }
    }
    
    var defaultPhotoImage: UIImage? {
        guard let status = self.dailyHabitModel.responseModel.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return UIImage(named: "photo_default")
            case .delayPenalty:
                fallthrough
            case .delay:
                return UIImage(named: "photo_delay")
        }
    }
    
    var contentText: String? {
        guard let status = self.dailyHabitModel.responseModel.castingHabitStatus
        else { return nil }
        
        switch status {
            case .success:
                return self.dailyHabitModel.responseModel.content
            case .delayPenalty:
                fallthrough
            case .delay:
                return self.dailyHabitModel.sentenceForDelay
        }
    }
    
    var dateText: String? {
        self.dailyHabitModel.responseModel
            .createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "yyyy-MM-dd")
    }
    
    var timeText: String? {
        self.dailyHabitModel.responseModel
            .createDateTime
            .convertToDate(format: DailyHabitResponseModel.dateFormat)?
            .convertString(format: "h:mm a", amSymbol: "AM", pmSymbol: "PM")
    }
}
