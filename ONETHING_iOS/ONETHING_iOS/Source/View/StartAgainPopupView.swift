//
//  FirstAgainPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

final class StartAgainPopupView: NNConfirmPopupView {
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let subTitleLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    override func setupContentView() {
        super.setupContentView()
        
        self.setupTitleLabel()
        self.setupSubTitleLabel()
    }
    
    override var heightOfContentView: CGFloat {
        return 184.0
    }
    
    func update(with viewModel: HabitManagingViewModel) {
        self.titleLabel.attributedText = viewModel.titleTextOfStartAgainPopupView
        self.subTitleLabel.attributedText = viewModel.subTitleTextOfStartAgainPopupView
    }
    
    private func setupTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupSubTitleLabel() {
        self.contentView.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20.0)
            $0.centerX.equalToSuperview()
        }
    }
}
