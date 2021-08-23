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
    weak var delegate: DelayPopupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func show(in targetController: UIViewController, completion: (() -> Void)? = nil) {
        targetController.view.addSubview(self)
        self.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.showCrossDissolve(completion: {
            completion?()
        })
    }
    
    func hide(completion: (() -> Void)? = nil) {
        self.hideCrossDissolve {
            completion?()
            self.removeFromSuperview()
        }
    }
}
