//
//  HabitShareType.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import UIKit

enum HabitShareUIType {
    
    case first
    case second
    case third
    case fourth
    
    var titleText: String {
        switch self {
        case .first:
            return "Congratulations!"
        case .second:
            return "66 days habit"
        case .third, .fourth:
            return "You did it!"
        }
    }
    
    var subTitleText: String {
        switch self {
        case .first:
            return "66일 습관 성공!"
        case .second:
            return "success!"
        case .third, .fourth:
            return ""
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
        case .first:
            return UIImage(named: "share_img_1")
        case .second:
            return UIImage(named: "share_img_2")
        case .third:
            return UIImage(named: "share_img_3")
        case .fourth:
            return UIImage(named: "share_img_4")
        }
    }
    
    var buttonImage: UIImage? {
        switch self {
        case .first:
            return UIImage(named: "share_btn_1")
        case .second:
            return UIImage(named: "share_btn_2")
        case .third:
            return UIImage(named: "share_btn_3")
        case .fourth:
            return UIImage(named: "share_btn_4")
        }
    }
    
}
