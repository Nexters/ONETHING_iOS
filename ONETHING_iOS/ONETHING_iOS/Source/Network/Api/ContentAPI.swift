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
    case createHabit(title: String, sentence: String, pushTime: String, penaltyCount: Int)
    case modifyHabit(habitId: Int, color: String, pushTime: String, penaltyCount: Int)
    case createDailyHabit(habitId: Int, createDateTime: String, status: String, content: String, stampType: String, image: UIImage)
    case getHabitInProgress
    case getHabits
    case getDailyHistories(habitId: Int)
    case getDailyHabitImage(createDate: String, imageExtension: String)
    case getNotices
    case getQuestions
}

extension ContentAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServerHost.main)!
    }
    
    var path: String {
        switch self {
        case .getRecommendedHabit:
            return "/api/habit-recommend"
        case .createHabit, .modifyHabit:
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
            return "/api/habit/history/image"
        case .getNotices:
            return "/api/info/notices"
        case .getQuestions:
            return "/api/info/questions"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getRecommendedHabit, .getHabitInProgress, .getHabits,
                 .getDailyHistories, .getDailyHabitImage, .getNotices, .getQuestions:
            return .get
        case .createHabit, .createDailyHabit:
            return .post
        case .modifyHabit:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRecommendedHabit, .getHabitInProgress, .getHabits, .getDailyHistories(_), .getNotices, .getQuestions:
            return .requestPlain
        case .createHabit(let title, let sentence, let pushTime, let penaltyCount):
            let parameters: [String: Any] = ["title": title, "sentence": sentence,
                                             "pushTime": pushTime, "penaltyCount": penaltyCount]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .modifyHabit(let habitId, let color , let pushTime, let penaltyCount):
            let parameters: [String: Any] = ["habitId": habitId, "color": color,
                                             "pushTime": pushTime, "penaltyCount": penaltyCount]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createDailyHabit(_, let createDateTime, let status, let content, let stampType, let image):
            let dateData = MultipartFormData(provider: .data(createDateTime.data(using: .utf8)!), name: "createDateTime")
            let statusData = MultipartFormData(provider: .data(status.data(using: .utf8)!), name: "status")
            let contentData = MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
            let stampData = MultipartFormData(provider: .data(stampType.data(using: .utf8)!), name: "stampType")
            let imageData = MultipartFormData(
                provider: .data(image.jpegData(compressionQuality: 0.1)!),
                name: "image")
            return .uploadMultipart([dateData, statusData, contentData, stampData, imageData])
        case .getDailyHabitImage(let createDate, let imageExtension):
            let parameters: [String: Any] = ["createDate": createDate, "imageExtension": imageExtension]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
            case .createDailyHabit:
                return [NetworkInfomation.HeaderKey.authorization: NetworkInfomation.HeaderValue.authorization]
            default:
                return NetworkInfomation.headers
        }
    }
}


