//
//  ConfirmPopupView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/18.
//

import RxSwift
import RxCocoa
import UIKit

final class ConfirmPopupView: UIView {

    typealias Handler = () -> Void
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bindButtons()
    }
    
    func configure(_ title: String, confirmHandler: Handler? = nil, cancelHandler: Handler? = nil) {
        self.titleLabel.text = title
        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler
    }
    
    func configure(_ attributeText: NSAttributedString, confirmHandler: Handler? = nil, cancelHandler: Handler? = nil) {
        self.titleLabel.attributedText = attributeText
        self.confirmHandler = confirmHandler
        self.cancelHandler = cancelHandler
    }

    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.showCrossDissolve()
    }
    
    func hide(completion: Handler?) {
        self.hideCrossDissolve { [weak self] in
            completion?()
            self?.removeFromSuperview()
        }
    }
    
    private func bindButtons() {
        self.confirmButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.hide(completion: self?.confirmHandler)
        }).disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.hide(completion: self?.cancelHandler)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private var cancelHandler: Handler?
    private var confirmHandler: Handler?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
}
