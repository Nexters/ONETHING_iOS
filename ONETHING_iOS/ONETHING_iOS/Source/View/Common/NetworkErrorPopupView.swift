//
//  NetworkErrorPopupView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/30.
//

import RxCocoa
import RxSwift
import UIKit

class NetworkErrorPopupView: UIView {
    
    typealias Completion = () -> Void
    
    static var isPresented: Bool {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        return keyWindow?.viewWithTag(ViewTag.networkErrorPopup) != nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tag = ViewTag.networkErrorPopup
    }

    func show(in view: UIView, completion: Completion?) {
        self.retryAction = completion
        
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.animateForShow()
    }
    
    func hide() {
        self.animateForHide { [weak self] in
            self?.retryAction?()
            self?.removeFromSuperview()
        }
    }
    
    @IBAction func retry(_ sender: Any) {
        self.hide()
    }
    
    private func animateForShow() {
        self.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    private func animateForHide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }

    private var retryAction: Completion?
    private let disposeBag = DisposeBag()
    
}
