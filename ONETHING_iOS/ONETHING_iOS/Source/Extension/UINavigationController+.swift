//
//  UIApplication+.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/16.
//

import UIKit


extension UINavigationController {
    var statusBar: StatusBar {
        if let statusBar = self.view.viewWithTag(ViewTag.statusBar) as? StatusBar {
            return statusBar
        } else {
            let statusBarFrame: CGRect = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
            let statusBar = StatusBar(frame: statusBarFrame)
            statusBar.tag = ViewTag.statusBar
            self.view.addSubview(statusBar)
            return statusBar
        }
    }
    
    class StatusBar: UIView {
        var previousBackgroundColor: UIColor? = .white
    }
}
