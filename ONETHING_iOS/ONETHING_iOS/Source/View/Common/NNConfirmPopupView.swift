//
//  NNConfirmPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

class NNConfirmPopupView: UIView {
    let contentView = UIView()
    private let underLine = UIView()
    private let verticalLine = UIView()
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    var confirmAction: ((NNConfirmPopupView) -> Void)?
    var cancelAction: ((NNConfirmPopupView) -> Void)?
    var backgroundDimView: BackgroundDimView?
    
    var heightOfContentView: CGFloat = 0.0 {
        didSet { self.layoutIfNeeded() }
    }
    
    var buttons: [UIButton] {
        return [self.confirmButton, self.cancelButton]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = 16.0
        self.backgroundColor = .white
        self.setupUI()
        self.layoutUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func removeFromSuperview() {
        self.backgroundDimView?.hideCrossDissolve()
        self.backgroundDimView?.removeFromSuperview()
        
        super.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutUI()
    }
    
    func setupUI() {
        self.underLine.backgroundColor = .black_10
        self.verticalLine.backgroundColor = .black_10
        
        self.confirmButton.do {
            $0.setTitle("네", for: .normal)
            $0.setTitleColor(.black_100, for: .normal)
            $0.titleLabel?.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16.0)
            $0.addTarget(self, action: #selector(self.invokeConfirmAction), for: .touchUpInside)
        }
        
        self.cancelButton.do {
            $0.setTitle("아니오", for: .normal)
            $0.setTitleColor(.black_100, for: .normal)
            $0.titleLabel?.font = UIFont(name: FontType.pretendard(weight: .regular).fontName, size: 16.0)
            $0.addTarget(self, action: #selector(self.invokeCancelAction), for: .touchUpInside)
        }

        self.addSubview(self.contentView)
        self.addSubview(self.underLine)
        self.addSubview(self.confirmButton)
        self.addSubview(self.verticalLine)
        self.addSubview(self.cancelButton)
    }
    
    func layoutUI() {
        self.contentView.snp.remakeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(self.heightOfContentView)
        }
        
        self.underLine.snp.makeConstraints{
            $0.top.equalTo(self.contentView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        self.confirmButton.snp.makeConstraints {
            $0.top.equalTo(self.underLine.snp.bottom)
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.width.equalTo(106.0)
        }
        
        self.verticalLine.snp.makeConstraints {
            $0.top.equalTo(self.confirmButton)
            $0.leading.equalTo(self.confirmButton.snp.trailing)
            $0.width.equalTo(1.0)
            $0.height.equalTo(self.confirmButton)
            $0.bottom.equalToSuperview()
        }
        
        self.cancelButton.snp.makeConstraints {
            $0.top.equalTo(self.underLine.snp.bottom)
            $0.leading.equalTo(self.verticalLine.snp.trailing)
            $0.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(self.confirmButton)
        }
    }
    
    func show(in view: UIView) {
        self.showBackgroundDimView(in: view)
        
        view.addSubview(self)
        self.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func showBackgroundDimView(in view: UIView) {
        let backgroundDimView = BackgroundDimView()
        view.addSubview(backgroundDimView)
        backgroundDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundDimView.showCrossDissolve(completedAlpha: BackgroundDimView.completedAlpha)
        self.backgroundDimView = backgroundDimView
    }
    
    @objc private func invokeConfirmAction() {
        self.confirmAction?(self)
    }

    @objc private func invokeCancelAction() {
        self.cancelAction?(self)
    }
}
