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
    case getHabitInProgress
    case getHabits
    case postHabit
    case getDailyHistories(habitId: Int)
}

extension ContentAPI: TargetType {
    var baseURL: URL {
        return URL(string: ServerHost.main)!
    }
    
    var path: String {
        switch self {
        case .getRecommendedHabit:
            return "/api/habit-recommend"
        case .getHabitInProgress:
            return "/habit-in-progress"
        case .getHabits:
            return "/habits"
        case let .getDailyHistories(habitId: habitId):
            return "/habit/\(habitId)/daily-histories"
        case .postHabit:
            return "/habit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendedHabit, .getHabitInProgress,
             .getHabits, .getDailyHistories:
            return .get
        case .postHabit:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var parameters = [String: Any]()
        switch self {
        case .getRecommendedHabit, .getHabitInProgress,
             .getHabits, .postHabit:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getDailyHistories(habitId: let habitId):
            parameters[NetworkInfomation.Request.ParameterKeys.habitId] = habitId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return NetworkInfomation.headers
    }
}

