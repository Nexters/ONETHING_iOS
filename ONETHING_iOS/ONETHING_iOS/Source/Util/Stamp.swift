//
//  Stamp.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

enum Stamp: String, CaseIterable {
    case beige
    case yellow
    case gray
    case red
    case pink_2
    case pink_1
    case purple_1
    case purple_2
    case blue
    case mint
    case green_2
    case green_1
    
    var defaultImage: UIImage {
        switch self {
        case .beige:
            return UIImage(named: "stamp_beige")!
        case .yellow:
            return UIImage(named: "stamp_yellow")!
        case .gray:
            return UIImage(named: "stamp_gray")!
        case .red:
            return UIImage(named: "stamp_red")!
        case .pink_2:
            return UIImage(named: "stamp_pink_2")!
        case .pink_1:
            return UIImage(named: "stamp_pink_1")!
        case .purple_1:
            return UIImage(named: "stamp_purple_1")!
        case .purple_2:
            return UIImage(named: "stamp_purple_2")!
        case .blue:
            return UIImage(named: "stamp_blue")!
        case .mint:
            return UIImage(named: "stamp_mint")!
        case .green_2:
            return UIImage(named: "stamp_green_2")!
        case .green_1:
            return UIImage(named: "stamp_green_1")!
        }
    }
    
    var lockImage: UIImage? {
        switch self {
        case .pink_2:
            return UIImage(named: "stamp_pink_2_lock")!
        case .pink_1:
            return UIImage(named: "stamp_pink_1_lock")!
        case .purple_1:
            return UIImage(named: "stamp_purple_1_lock")!
        case .purple_2:
            return UIImage(named: "stamp_purple_2_lock")!
        case .blue:
            return UIImage(named: "stamp_blue_lock")!
        case .mint:
            return UIImage(named: "stamp_mint_lock")!
        case .green_2:
            return UIImage(named: "stamp_green_2_lock")!
        case .green_1:
            return UIImage(named: "stamp_green_1_lock")!
        default:
            return nil
        }
    }
}
