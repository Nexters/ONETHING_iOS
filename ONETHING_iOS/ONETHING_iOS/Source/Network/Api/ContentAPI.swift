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
    case createDailyHabit(habitId: Int, date: String, status: String, content: String, stickerId: String, image: NSData)
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
        case .createDailyHabit(_, let date, let status, let content, let stickerId, let image):
            let parameters: [String: Any] = ["date": date, "status": status,
                                             "content": content, "stickerId": stickerId, "image": image]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return NetworkInfomation.headers
    }
}

