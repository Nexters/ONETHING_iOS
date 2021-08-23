//
//  DelayPopupView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/23.
//

import UIKit

protocol DelayPopupViewDelegate: AnyObject {
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView)
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView)
}

final class DelayPopupView: UIView {
    private let guideLabel = UILabel().then {
        $0.text = "미룸벌칙을 완료해야만 서비스를 이용할 수 있어요!"
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 12)
    }
    
    weak var delegate: DelayPopupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func show(in targetController: UIViewController, completion: (() -> Void)? = nil) {
        targetController.view.addSubview(self)
        self.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.setupGuideLabel(with: targetController)
        
        self.showCrossDissolve(completion: {
            completion?()
        })
    }
    
    func setupGuideLabel(with targetController: UIViewController) {
        targetController.view.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        self.hideCrossDissolve {
            completion?()
            self.removeFromSuperview()
            self.guideLabel.removeFromSuperview()
        }
    }
    
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
