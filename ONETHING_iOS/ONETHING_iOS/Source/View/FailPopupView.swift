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
    func failPopupViewDidTapCloseButton()
}

final class FailPopupView: UIView, ShakeView {
    weak var delegate: FailPopupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bindButtons()
    }
    
    private func bindButtons() {
        self.closeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.delegate?.failPopupViewDidTapCloseButton()
            self?.hide()
        }).disposed(by: self.disposeBag)
    }
    
    func configure(with viewModel: FailPopupViewPresentable) {
        self.titleLabel.text = viewModel.titleTextOfFailPopupView
        self.progressCountLabel.text = viewModel.progressCountTextOfFailPopupView
        self.reasonLabel.text = viewModel.reasonTextOfFailPopupView
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
    
    @IBOutlet private weak var closeButton: UIButton!
}
