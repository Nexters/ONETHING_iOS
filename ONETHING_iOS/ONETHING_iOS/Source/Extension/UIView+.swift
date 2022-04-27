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
    
    static var splashView: UIView? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.viewWithTag(ViewTag.splashView)
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
    
    func showCrossDissolve(_ duration: TimeInterval = 0.2, completedAlpha: CGFloat = 1.0, completion: (() -> Void)? = nil) {
        self.isHidden = false
        self.alpha = 0
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = completedAlpha
        }, completion: { _ in
            completion?()
        })
    }
    
    func hideCrossDissolve(_ duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: { [weak self] _ in
            self?.isHidden = true
            completion?()
        })
    }
    
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { renderImageContext in
            self.layer.render(in: renderImageContext.cgContext)
        }
    }
    
}

extension UIView {
    func animateShaking() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}

