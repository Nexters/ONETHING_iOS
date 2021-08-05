//
//  Api.swift
//  ONETHING
//
//  Created by sdean on 2021/07/18.
//

import Foundation

import Moya

enum ContentAPI {
    case getRecommendedHabit
    case createHabit(title: String, sentence: String, pushTime: String, delayMaxCount: Int)
    case createDailyHabit(habitId: Int, dailyHabitOrder: Int, date: String, status: String, content: String, stickerId: String, image: UIImage)
    case getHabitInProgress
    case getHabits
    case getDailyHistories(habitId: Int)
    case getDailyHabitImage
}

extension ContentAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServerHost.main)!
    }
    
    var path: String {
        switch self {
        case .getRecommendedHabit:
            return "/api/habit-recommend"
        case .createHabit:
            return "/api/habit"
        case .getHabitInProgress:
            return "/api/habit-in-progress"
        case .getHabits:
            return "/api/habits"
        case let .getDailyHistories(habitId: habitId):
            return "/api/habit/\(habitId)/daily-histories"
        case let .createDailyHabit(habitId: habitId):
            return "api/habit/\(habitId)/history"
        case .getDailyHabitImage:
            return "api/history/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getRecommendedHabit, .getHabitInProgress, .getHabits,
                 .getDailyHistories, .getDailyHabitImage:
            return .get
        case .createHabit, .createDailyHabit:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRecommendedHabit, .getHabitInProgress, .getHabits, .getDailyHistories(_), .getDailyHabitImage:
            return .requestPlain
        case .createHabit(let title, let sentence, let pushTime, let delayMaxCount):
            let parameters: [String: Any] = ["title": title, "sentence": sentence,
                                             "pushTime": pushTime, "delayMaxCount": delayMaxCount]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createDailyHabit:
            return .uploadMultipart(self.multipartFormData!)
        }
    }
    
    var multipartFormData: [MultipartFormData]? {
        switch self {
            case .createDailyHabit(let habitId, let dailyHabitOrder, let date, let status, let content, let stickerId, let image):
                let dateData = MultipartFormData(provider: .data(date.data(using: .utf8)!), name: "date")
                let statusData = MultipartFormData(provider: .data(status.data(using: .utf8)!), name: "status")
                let contentData = MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
                let stickerIdData = MultipartFormData(provider: .data(stickerId.data(using: .utf8)!), name: "stickerId")
                
                let imageMultiFormData = Moya.MultipartFormData(
                    provider: MultipartFormData.FormDataProvider.data(image.jpegData(compressionQuality: 0.7)!),
                    name: "image",
                    fileName: "habitId:\(habitId), dailyHabitOrder:\(dailyHabitOrder).jpg",
                    mimeType: "image/jpeg")
                
                return [dateData, statusData, contentData, stickerIdData, imageMultiFormData]
            default:
                return nil
        }
    }
    
    var headers: [String: String]? {
        return NetworkInfomation.headers
    }
}

