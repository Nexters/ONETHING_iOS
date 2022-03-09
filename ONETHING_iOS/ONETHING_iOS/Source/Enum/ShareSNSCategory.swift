//
//  ShareSNSCategory.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import UIKit

enum ShareSNSCategory {
    
    case instagram
    case saveImage
    case etc
    
    var title: String {
        switch self {
        case .instagram:
            return "인스타그램 스토리"
        case .saveImage:
            return "이미지 저장"
        case .etc:
            return "기타"
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .instagram:
            return UIImage(named: "share_insta")
        case .saveImage:
            return UIImage(named: "share_download")
        case .etc:
            return UIImage(named: "share_etc")
        }
    }
    
    var iconBackgroudColor: UIColor {
        switch self {
        case .instagram:
            return .clear
        case .saveImage:
            return .red_3
        case .etc:
            return .black_10
        }
    }
    
}
