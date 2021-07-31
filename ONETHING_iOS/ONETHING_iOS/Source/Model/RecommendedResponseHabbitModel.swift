//
//  RecommendHabbitModel.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/30.
//

import UIKit

struct RecommendedHabitResponseModel: Codable {
    
    let habitRecommend: [RecommendHabitModel]?
    
}
 
struct RecommendHabitModel: Codable {
    
    let habbitRecommendId: Int?
    let title: String?
    let shpae: String?
    let color: String?
    
}

extension RecommendHabitModel {
    
    enum OnethingShape: String {
        case circle
        case square
        
        var cornerRadius: CGFloat {
            switch self {
            case .circle: return 25
            case .square: return 14
            }
        }
    }
    
    var onethingColor: UIColor {
        guard let color = self.color else { return .green_1 }
        guard let onethingColor = OnethingColor(rawValue: color) else { return .green_1 }
        return onethingColor.color
    }
    
    var onethingShape: OnethingShape {
        guard let shape = self.shpae else { return .square }
        guard let onethingShape = OnethingShape(rawValue: shape) else { return .square }
        return onethingShape
    }
    
}
