//
//  NotifyPopupView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 11/03/2022.
//

import UIKit

import RxCocoa
import RxSwift

final class NotifyPopupView: UIView {
    private let contentView = UIView()
    private let horizontalLineView = UIView()
    private let closeButton = UIButton()
    private var dimView: BackgroundDimView?
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupContentView()
        self.setupHorizontalLineView()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.dimView?.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func show(in superview: UIView) {
        let dimView = BackgroundDimView()
        superview.addSubview(dimView)
        dimView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        self.dimView = dimView
        
        superview.addSubview(self)
        self.snp.makeConstraints({
            $0.centerX.centerY.equalToSuperview()
        })
    }
    
    private func setupContentView() {
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints({
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(self.heightOfContentView)
        })
    }
    
    func layout(layoutHandler: (UIView) -> Void) {
        layoutHandler(self.contentView)
    }
    
    var heightOfContentView: CGFloat {
        return 0.0
    }
    
    private func setupHorizontalLineView() {
        self.addSubview(self.horizontalLineView)
        self.horizontalLineView.snp.makeConstraints({
            $0.leading.trailing.equalTo(self.contentView)
            $0.top.equalTo(self.contentView.snp.bottom)
            $0.height.equalTo(1.0)
        })
    }
    
    private func setupCancelButton() {
        self.closeButton.rx.tap.observeOnMain(onNext: { [weak self] _ in
            self?.removeFromSuperview()
        }).disposed(by: self.disposeBag)
        
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints({
            $0.top.equalTo(self.horizontalLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
}
