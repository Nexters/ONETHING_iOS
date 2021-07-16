//
//  UIApplication+.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/16.
//

import UIKit


extension UINavigationController {
    
    var statusBar: StatusBar {
        let statusBarViewTag = 3848245
        if let statusBar = self.view.viewWithTag(statusBarViewTag) as? StatusBar {
            return statusBar
        } else {
            let statusBarFrame: CGRect = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
            let statusBar = StatusBar(frame: statusBarFrame)
            statusBar.tag = statusBarViewTag
            self.view.addSubview(statusBar)
            return statusBar
        }
    }
    
    class StatusBar: UIView {
        var previousBackgroundColor: UIColor? = .white
    }
}
