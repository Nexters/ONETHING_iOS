//
//  ProfileImageType.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/22.
//

import UIKit

enum OnethingProfileType: String, CaseIterable {
    case study = "STUDY"
    case strong = "STRONG"
    case heart = "HEART"
    
    var image: UIImage? {
        switch self {
        case .heart: return #imageLiteral(resourceName: "profile_heart")
        case .strong: return #imageLiteral(resourceName: "profile_strong")
        case .study: return #imageLiteral(resourceName: "profile_study")
        }
    }
}


