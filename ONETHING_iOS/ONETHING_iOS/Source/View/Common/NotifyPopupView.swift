//
//  NotifyPopupView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 11/03/2022.
//

import UIKit

import RxCocoa
import RxSwift

class NotifyPopupView: UIView {
    let contentView = UIView()
    private let horizontalLineView = UIView()
    private let closeButton = UIButton()
    private var dimView: BackgroundDimView?
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = 16.0
        self.backgroundColor = .white
        self.setupContentView()
        self.setupHorizontalLineView()
        self.setupCancelButton()
    }
    
    override func removeFromSuperview() {
        self.dimView?.hideCrossDissolve()
        self.dimView?.removeFromSuperview()
        
        super.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func show(in superview: UIView) {
        self.showDimView(in: superview)
        
        superview.addSubview(self)
        self.snp.makeConstraints({
            $0.centerX.centerY.equalToSuperview()
        })
    }
    
    private func showDimView(in superview: UIView) {
        let dimView = BackgroundDimView()
        superview.addSubview(dimView)
        dimView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        dimView.showCrossDissolve(completedAlpha: dimView.completedAlpha)
        self.dimView = dimView
    }
    
    func setupContentView() {
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints({
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(self.heightOfContentView)
        })
    }
    
    var heightOfContentView: CGFloat {
        return 0
    }
    
    private func setupHorizontalLineView() {
        self.horizontalLineView.backgroundColor = .black_10
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
        
        self.closeButton.do {
            $0.setTitle("닫기", for: .normal)
            $0.setTitleColor(.black_100, for: .normal)
            $0.titleLabel?.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16.0)
        }
        
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints({
            $0.top.equalTo(self.horizontalLineView.snp.bottom)
            $0.height.equalTo(44.0)
            $0.width.equalTo(214.0)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
}
