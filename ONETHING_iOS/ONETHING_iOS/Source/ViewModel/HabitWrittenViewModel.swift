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

final class HabitWrittenViewModel {
    private let dailyHabitModel: DailyHabitResponseModel
    private let apiService: APIService<ContentAPI>
    private let imageCache: Kingfisher.ImageCache
    
    init(dailyHabitModel: DailyHabitResponseModel,
         apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>()),
         imageCache: Kingfisher.ImageCache = Kingfisher.ImageCache.default) {
        self.dailyHabitModel = dailyHabitModel
        self.apiService = apiService
        self.imageCache = imageCache
    }
    
    func requestHabitImage() -> Observable<Image> {
        return Observable.create { [weak self] emitter in
            guard let self = self,
                  let createDate: String = self.dailyHabitModel.createDateTime
                    .convertToDate(format: self.dailyHabitModel.dateFormat)?
                    .convertString(format: "yyyy-MM-dd") else { return Disposables.create() }
            
            // check first if image is in momoey cache
            let photoImage = self.imageCache.retrieveImageInMemoryCache(forKey: createDate)
            if photoImage != nil {
                emitter.onNext(photoImage!)
                return Disposables.create()
            }
            
            self.fetchAndStoreImageOnMemory(
                createDate: createDate,
                imageExtension: self.dailyHabitModel.imageExtension ?? "jpg"
            ) { (photoImage: UIImage) in
                
                emitter.onNext(photoImage)
                
            }
            
            return Disposables.create()
        }
    }
    
    private func fetchAndStoreImageOnMemory(createDate: String, imageExtension: String, completionHandler: @escaping (UIImage) -> Void) {
        let api = ContentAPI.getDailyHabitImage(
            createDate: createDate,
            imageExtension:  imageExtension
        )
        
        self.apiService.request(api: api) { (photoImageData: Data) in
            guard let photoImage = UIImage(data: photoImageData) else { return }
            
            // store image to memory cache
            self.imageCache.store(photoImage, forKey: createDate, toDisk: false)
            completionHandler(photoImage)
        }
    }
    
    var currentStampImage: UIImage? {
        self.dailyHabitModel.castringStamp?.defaultImage
    }
    
    var contentText: String? {
        self.dailyHabitModel.content
    }
}
