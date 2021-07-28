//
//  LockPopupView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/28.
//

import UIKit

final class LockView: UIView {
    var topAnchorConstraint: NSLayoutConstraint?
    private let mainLabel = UILabel().then {
        $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = "습관 22일을 달성하면\n사용할 수 있어요!"
    }
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupMainImageView()
        self.setupMainLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.layer.cornerRadius = 13
        self.backgroundColor = .white
    }
    
    private func setupMainImageView() {
        self.addSubview(self.mainImageView)
        
        self.mainImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(46)
        }
    }
    
    private func setupMainLabel() {
        self.addSubview(self.mainLabel)
        
        self.mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func update(text: String) {
        self.mainLabel.text = text
    }
    
    func update(image: UIImage?) {
        self.mainImageView.image = image
    }
}
