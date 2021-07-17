//
//  DeviceInfo.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/17.
//

import UIKit

struct DeviceInfo {
    
    static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    
    static var safeAreaBottomInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    static var safeAreaTopInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
    
    static var safeAreaLeadingInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0
    }
    
    static var safeAreaTrailingInset: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0
    }

}
