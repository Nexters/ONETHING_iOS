//
//  UILoadingIndicator+.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

extension UIActivityIndicatorView {
    func showAndStart() {
        self.isHidden = false
        self.startAnimating()
    }
    
    func hideAndStop() {
        self.isHidden = true
        self.stopAnimating()
    }
}
