//
//  BackBtnTitleView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import UIKit

final class BackBtnTitleView: UIView {
    private weak var parentViewController: UIViewController?
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    init(frame: CGRect = .zero, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        self.setupBackButton()
        self.setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    private func setupBackButton() {
        self.backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        self.backButton.contentMode = .scaleAspectFit
        self.backButton.addTarget(self, action: #selector(backButtonDidTouch(button:)), for: .touchUpInside)
        
        self.addSubview(backButton)
        self.backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(self.backButtonDiameter)
            $0.height.equalTo(self.backButton.snp.width)
        }
    }
    
    @objc private func backButtonDidTouch(button: UIButton?) {
        guard let parentViewController = self.parentViewController else { return }
        
        parentViewController.navigationController?.popViewController(animated: true)
    }
    
    private func setupTitleLabel() {
        self.titleLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.backButton.snp.trailing).offset(10)
            $0.centerY.equalTo(self.backButton)
            $0.trailing.equalToSuperview()
        }
    }
    
    func update(title text: String) {
        self.titleLabel.text = text
    }
    
    var backButtonDiameter: CGFloat {
        return 24
    }
}
