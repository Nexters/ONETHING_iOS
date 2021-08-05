//
//  HabitWrittenViewModel.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/03.
//

import Foundation

import Moya
import RxSwift

final class HabitWrittenViewModel {
    private var dailyHabitModel: DailyHabitResponseModel?
    private let apiService: APIService<ContentAPI>
    
    init(apiService: APIService<ContentAPI> = APIService(provider: MoyaProvider<ContentAPI>())) {
        self.apiService = apiService
        
    }
    
    func requestAndGetHabitImage() -> Observable<Image?> {
        return Observable.create { [weak self] emitter in
            if let self = self {
                self.apiService.requestAndDecode(api: .getDailyHabitImage) { (photoImageData: Data) in
                    emitter.onNext(UIImage(data: photoImageData))
                }
            }
            return Disposables.create()
        }
    }
    
    func update(dailyHabitModel: DailyHabitResponseModel) {
        self.dailyHabitModel = dailyHabitModel
    }
    
    var currentStampImage: UIImage? {
        self.dailyHabitModel?.castringStamp?.defaultImage
    }
    
    var contentText: String? {
        self.dailyHabitModel?.content
    }
}
