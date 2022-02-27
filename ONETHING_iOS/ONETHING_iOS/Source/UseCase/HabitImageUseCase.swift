//
//  HabitImageUseCase.swift
//  ONETHING
//
//  Created by sdean on 2021/08/08.
//

import UIKit

import Kingfisher
import Moya
import RxSwift

final class HabitImageUseCase {
    private let imageCache: Kingfisher.ImageCache
    private let apiService: APIServiceType
    private let disposeBag = DisposeBag()
    
    init(imageCache: Kingfisher.ImageCache = Kingfisher.ImageCache.default,
         apiService: APIServiceType = APIService.shared) {
        self.imageCache = imageCache
        self.apiService = apiService
    }
    
    func requestHabitImage(createDate: String, imageExtension: String, completionHandler: @escaping (UIImage) -> Void) {
        // check first if image is in momoey cache
        let photoImage = self.imageCache.retrieveImageInMemoryCache(forKey: createDate)
        
        if photoImage != nil {
            completionHandler(photoImage!)
            return
        }
        
        self.fetchAndStoreImageOnMemory(
            createDate: createDate,
            imageExtension: imageExtension
        ) { (photoImage: UIImage) in
            
            completionHandler(photoImage)
        }
    }
    
    private func fetchAndStoreImageOnMemory(createDate: String, imageExtension: String, completionHandler: @escaping (UIImage) -> Void) {
        let api = ContentAPI.getDailyHabitImage(
            createDate: createDate,
            imageExtension:  imageExtension
        )
        
        self.apiService.requestRx(apiTarget: api, retryHandler: nil)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                guard response.statusCode == 200 else { return }
                
                let imageData = response.data
                guard let photoImage = UIImage(data: imageData) else { return }
                
                // store image to memory cache
                owner.imageCache.store(photoImage, forKey: createDate, toDisk: false)
                completionHandler(photoImage)
            })
            .disposed(by: self.disposeBag)
    }
}
