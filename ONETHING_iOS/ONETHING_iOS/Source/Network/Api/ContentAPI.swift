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
    case editHabit(habitId: Int, color: String, pushTime: String, penaltyCount: Int)
    case deleteHabit(habitId: Int)
    case createDailyHabit(habitId: Int, createDateTime: String, status: String, content: String, stampType: String, image: UIImage)
    case getHabitInProgress
    case getHabits
    case getUnseenStatus
    case putPassDelayPenalty(habitId: Int)
    case putGiveUpHabit
    case putUnSeenSuccess(habitId: Int)
    case putUnSeenFail(habitId: Int)
    case putReStart(habitId: Int)
    case getDailyHistories(habitId: Int)
    case getDailyHabitImage(habitHistoryID: Int)
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
        case .createHabit, .editHabit:
            return "/api/habit"
        case let .deleteHabit(habitId: habitId):
            return "/api/habit/\(habitId)"
        case .getHabitInProgress:
            return "/api/habit-in-progress"
        case .getHabits:
            return "/api/habits"
        case .getUnseenStatus:
            return "/api/habit-in-unseen-status"
        case let .putPassDelayPenalty(habitId: habitId):
            return "/api/habit/\(habitId)/history/pass-delay-penalty"
        case .putGiveUpHabit:
            return "/api/habit-failure"
        case let .putUnSeenSuccess(habitId: habitId):
            return "/api/habit/\(habitId)/pass-unseen-success"
        case let .putUnSeenFail(habitId: habitId):
            return "api/habit/\(habitId)/pass-unseen-fail"
        case let .putReStart(habitId: habitId):
            return "api/habit/\(habitId)/restart"
        case let .getDailyHistories(habitId: habitId):
            return "/api/habit/\(habitId)/daily-histories"
        case let .createDailyHabit(habitId: habitId):
            return "api/habit/\(habitId)/history"
        case let .getDailyHabitImage(habitHistoryID: habitHistoryID):
            return "/api/habit/history/\(habitHistoryID)/image"
        case .getNotices:
            return "/api/info/notices"
        case .getQuestions:
            return "/api/info/questions"
                
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendedHabit, .getHabitInProgress, .getHabits,
             .getDailyHistories, .getDailyHabitImage, .getUnseenStatus, .getNotices, .getQuestions:
            return .get
        case .createHabit, .createDailyHabit:
            return .post
        case .editHabit, .putPassDelayPenalty, .putGiveUpHabit, .putUnSeenSuccess, .putUnSeenFail, .putReStart:
            return .put
        case .deleteHabit:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getRecommendedHabit, .getHabitInProgress, .getHabits, .getDailyHistories(_),
                .getNotices, .getQuestions, .getUnseenStatus, .putPassDelayPenalty, .putGiveUpHabit, .putUnSeenSuccess, .putUnSeenFail, .putReStart, .deleteHabit, .getDailyHabitImage(_):
            return .requestPlain
        case .createHabit(let title, let sentence, let pushTime, let penaltyCount):
            let parameters: [String: Any] = ["title": title, "sentence": sentence,
                                             "pushTime": pushTime, "penaltyCount": penaltyCount]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .editHabit(let habitId, let color , let pushTime, let penaltyCount):
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
