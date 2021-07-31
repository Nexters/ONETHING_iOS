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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindButtons()
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
            self?.removeFromSuperview()
        }
    }
    
    private func bindButtons() {
        self.retryButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.animateForHide {
                self?.retryAction?()
                self?.removeFromSuperview()
            }
        }).disposed(by: self.disposeBag)
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

    @IBOutlet private weak var retryButton: UIButton!
    
}
