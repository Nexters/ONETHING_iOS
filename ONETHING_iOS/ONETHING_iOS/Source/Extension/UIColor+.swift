//
//  UIColor+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0xFF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
    
}

extension UIColor {
        
    // Color Asset 모음
    @nonobjc static var black_100: UIColor      { return UIColor(hexString: "#393939") }
    @nonobjc static var black_80: UIColor       { return UIColor(hexString: "#616161") }
    @nonobjc static var black_60: UIColor       { return UIColor(hexString: "#888888") }
    @nonobjc static var black_40: UIColor       { return UIColor(hexString: "#B0B0B0") }
    @nonobjc static var black_20: UIColor       { return UIColor(hexString: "#D7D7D7") }
    @nonobjc static var black_10: UIColor       { return UIColor(hexString: "#EBEBEB") }
    @nonobjc static var black_5: UIColor        { return UIColor(hexString: "#F5F5F5") }
    @nonobjc static var red_3: UIColor          { return UIColor(hexString: "#FF9950") }
    @nonobjc static var red_2: UIColor          { return UIColor(hexString: "#FF8080") }
    @nonobjc static var red_1: UIColor          { return UIColor(hexString: "#FFCBCB") }
    @nonobjc static var gray_default: UIColor   { return UIColor(hexString: "#D4D4D4") }
    @nonobjc static var beige: UIColor          { return UIColor(hexString: "#FEEACD") }
    @nonobjc static var yellow_1: UIColor { return UIColor(hexString: "#FFB32E") }
    @nonobjc static var yellow_2: UIColor       { return UIColor(hexString: "#FFA80F") }
    @nonobjc static var red_default: UIColor    { return UIColor(hexString: "#FF6650") }
    @nonobjc static var pink_1: UIColor         { return UIColor(hexString: "#F391BC") }
    @nonobjc static var pink_2: UIColor         { return UIColor(hexString: "#F38193") }
    @nonobjc static var purple_1: UIColor       { return UIColor(hexString: "#E4B7D5") }
    @nonobjc static var purple_2: UIColor       { return UIColor(hexString: "#9F91F3") }
    @nonobjc static var blue_default: UIColor         { return UIColor(hexString: "#6E97FF") }
    @nonobjc static var green_1: UIColor        { return UIColor(hexString: "#CAE089") }
    @nonobjc static var green_2: UIColor        { return UIColor(hexString: "#97D1A9") }
    @nonobjc static var mint_1: UIColor         { return UIColor(hexString: "#A0D9D9") }
    @nonobjc static var mint_2: UIColor         { return UIColor(hexString: "#85D1D1") }
    
}

enum OnethingColor: String {
    case red_3
    case red_2
    case red_1
    case black_40
    case beige
    case yellow_1
    case red_default = "red"
    case pink_1
    case pink_2
    case purple_1
    case purple_2
    case mint_1
    case blue = "blue"
    case green_1
    case green_2
    
    var color: UIColor {
        switch self {
        case .red_3: return .red_3
        case .red_2: return .red_2
        case .red_1: return .red_1
        case .black_40:  return .black_40
        case .beige: return .beige
        case .yellow_1: return .yellow_1
        case .red_default: return .red_default
        case .pink_1: return .pink_1
        case .pink_2: return .pink_2
        case .purple_1: return .purple_1
        case .purple_2: return .purple_2
        case .blue: return .blue_default
        case .mint_1: return .mint_1
        case .green_1: return .green_1
        case .green_2: return .green_2
        }
    }
}
