//
//  BackBtnTitleView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import UIKit

final class BackBtnTitleView: UIView {
    let backButton = UIButton()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
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
        
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(self.backButtonDiameter)
            $0.height.equalTo(self.backButton.snp.width)
        }
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
    
    func update(with viewModel: HabitWritingViewModel?) {
        self.titleLabel.text = viewModel?.titleText
    }
    
    var backButtonDiameter: CGFloat {
        return 24
    }
}
