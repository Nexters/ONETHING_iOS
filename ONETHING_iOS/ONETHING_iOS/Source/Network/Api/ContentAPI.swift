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
    case createDailyHabit(habitId: Int, dailyHabitOrder: Int, createDateTime: String, status: String, content: String, stampType: String, image: UIImage)
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
        case .createDailyHabit(let habitId, let dailyHabitOrder, let createDateTime, let status, let content, let stampType, let image):
            let parameters: [String: Any] = ["createDateTime": createDateTime,
                                             "status": status,
                                             "content": content,
                                             "stampType": stampType,
                                             "image": image.jpegData(compressionQuality: 0.1)!]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        }
    }
    
    var multipartFormData: [Moya.MultipartFormData]? {
        switch self {
            case .createDailyHabit(let habitId, let dailyHabitOrder, let createDateTime, let status, let content, let stickerId, let image):
                let dateData = Moya.MultipartFormData(provider: .data(createDateTime.data(using: .utf8)!), name: "createDateTime")
                let statusData = Moya.MultipartFormData(provider: .data(status.data(using: .utf8)!), name: "status")
                let contentData = Moya.MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
                let stampData = Moya.MultipartFormData(provider: .data(stickerId.data(using: .utf8)!), name: "stampType")
                let imageMultiFormData = Moya.MultipartFormData(
                    provider: Moya.MultipartFormData.FormDataProvider.data(image.jpegData(compressionQuality: 0.1)!),
                    name: "image")
                
                return [dateData, statusData, contentData, stampData, imageMultiFormData]
            default:
                return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
            case .createDailyHabit:
                return [NetworkInfomation.Request.HeaderKeys.authorization: NetworkInfomation.Request.HeaderValues.authorization]
            default:
                break
        }
        
        return NetworkInfomation.headers
    }
}


