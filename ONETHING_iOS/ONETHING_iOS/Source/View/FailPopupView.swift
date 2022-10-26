//
//  FailPopupView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/24.
//

import UIKit

import RxSwift
import RxCocoa

protocol FailPopupViewDelegate: AnyObject {
    func failPopupViewDidTapClose(_ failPopupView: FailPopupView)
}

final class FailPopupView: UIView {
    enum FailReason {
        case unseen
        case giveup
    }
    
    weak var delegate: FailPopupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bindButtons()
    }
    
    private func bindButtons() {
        self.closeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.failPopupViewDidTapClose(self)
            self.hide()
        }).disposed(by: self.disposeBag)
    }
    
    func configure(with viewModel: FailPopupViewPresentable, reason: FailReason) {
        self.titleLabel.text = viewModel.titleTextOfFailPopupView
        self.progressCountLabel.text = viewModel.progressCountTextOfFailPopupView
        
        switch reason {
        case .unseen:
            self.reasonLabel.text = "사유: 습관 미루기 7회 이상"
        case .giveup:
            self.reasonLabel.text = "사유: 습관 그만하기"
        }
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
    
    func hide(_ duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        self.hideCrossDissolve(duration, completion: {
            self.removeFromSuperview()
            completion?()
        })
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressCountLabel: UILabel!
    @IBOutlet private weak var reasonLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
}
