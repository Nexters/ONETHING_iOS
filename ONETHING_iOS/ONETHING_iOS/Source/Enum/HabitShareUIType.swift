//
//  HabitShareType.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import UIKit

enum HabitShareUIType {
    
    case successFirst
    case successSecond
    case successThird
    case successFourth
    case failureFirst
    
    var titleText: String {
        switch self {
        case .successFirst:
            return "Congratulations!"
        case .successSecond:
            return "66 days habit"
        case .successThird, .successFourth:
            return "You did it!"
        case .failureFirst:
            return "Oops"
        }
    }
    
    var subTitleText: String {
        switch self {
        case .successFirst:
            return "66일 습관 성공!"
        case .successSecond:
            return "success!"
        case .successThird, .successFourth:
            return ""
        case .failureFirst:
            return "66일 습관은 여기까지...."
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
        case .successFirst:
            return UIImage(named: "share_img_1")
        case .successSecond:
            return UIImage(named: "share_img_2")
        case .successThird:
            return UIImage(named: "share_img_3")
        case .successFourth:
            return UIImage(named: "share_img_4")
        case .failureFirst:
            return UIImage(named: "share_img_fail")
        }
    }
    
    var buttonImage: UIImage? {
        switch self {
        case .successFirst:
            return UIImage(named: "share_btn_1")
        case .successSecond:
            return UIImage(named: "share_btn_2")
        case .successThird:
            return UIImage(named: "share_btn_3")
        case .successFourth:
            return UIImage(named: "share_btn_4")
        case .failureFirst:
            return nil
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .successFirst, .successSecond, .successThird, .successFourth:
            return .black_100
        case .failureFirst:
            return .black_80
        }
    }
    
}
