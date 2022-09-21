//
//  FirstAgainPopupView.swift
//  ONETHING_iOS
//
//  Created by kimdo2297 on 2022/03/04.
//

import UIKit

protocol TitleSubTitleConfirmViewModel: AnyObject {
    var titleText: NSAttributedString? { get }
    var subTitleText: NSAttributedString? { get }
}

final class TitleSubTitleConfirmPopupView: NNConfirmPopupView {
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTitleLabel)
    }
    
    override func layoutUI() {
        super.layoutUI()
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        self.subTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    func update(with viewModel: TitleSubTitleConfirmViewModel) {
        self.titleLabel.attributedText = viewModel.titleText
        self.subTitleLabel.attributedText = viewModel.subTitleText
    }
}
