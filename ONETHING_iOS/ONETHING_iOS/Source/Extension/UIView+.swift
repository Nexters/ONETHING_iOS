//
//  UIView+.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let borderColor = newValue else { return }
            self.layer.borderColor = borderColor.cgColor
        }
        
        get {
            guard let borderColor = self.layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { self.layer.borderWidth = newValue }
        get { return self.layer.borderWidth }
    }
    
    static var isExistNibFile: Bool {
        let nibName = String(describing: self)
        return Bundle.main.path(forResource: nibName, ofType: "nib") != nil
    }
    
    static func createFromNib<T: UIView>() -> T? {
        let identifier = String(describing: T.self)
        guard let nib = Bundle.main.loadNibNamed(identifier, owner: nil, options: nil) else { return nil }
        return nib.first as? T
    }
    
    /// 부분적으로 Corner Radius 줄 떄, [.bottomLeft, .bottomRight, .topLeft, .topRight, .allCorners] 선택 가능
    func makeCornerRadius(directions: UIRectCorner = .allCorners, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: directions,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask        = CAShapeLayer()
        mask.path       = path.cgPath
        self.layer.mask = mask
    }
    
}
