//
//  Api.swift
//  ONETHING
//
//  Created by sdean on 2021/07/18.
//

import Foundation

import Moya

enum Api {
    private enum RequestConfig {
        enum HeaderKeys {
            static let contentType = "Content-type"
            static let authorization = "Authorization"
        }
        
        enum HeaderValues {
            static let json =  "application/json"
            static let authorizationKey =  "bearer EbTnTgX_t1zEp67w27Yrgf2vsusWsaU5TjoivQo9dVsAAAF6kMJCqQ"
        }
        
        enum ParameterKeys {
            static let habitId = "habit_id"
        }
    }

    public enum ServiceMode: String {
        case live
        case test
    }
    
    // Naming: Method + EndPoint
    case getUser
    case getRecommendedHabit
    case getHabitInProgress
    case getHabits
    case postHabit
    case getDailyHistories(habitId: Int)
}

extension Api: TargetType {
    var baseURL: URL {
        return URL(string: "NONE, Not Yet.")!
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        case .getRecommendedHabit:
            return "/recommended-habit"
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
        case .getUser, .getRecommendedHabit, .getHabitInProgress,
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
        case .getUser, .getRecommendedHabit, .getHabitInProgress,
             .getHabits, .postHabit:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getDailyHistories(habitId: let habitId):
            parameters[RequestConfig.ParameterKeys.habitId] = habitId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return [RequestConfig.HeaderKeys.contentType: RequestConfig.HeaderValues.json,
                RequestConfig.HeaderKeys.authorization: RequestConfig.HeaderValues.authorizationKey]
    }
}

