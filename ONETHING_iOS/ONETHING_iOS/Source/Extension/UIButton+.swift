//
//  UIButton+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import UIKit

extension UIButton {
    
    @IBInspectable var imageTintColor: UIColor {
        get { return self.tintColor }
        set {
            let newImage = self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            self.setImage(newImage, for: .normal)
            self.tintColor = newValue
        }
    }
    
}
