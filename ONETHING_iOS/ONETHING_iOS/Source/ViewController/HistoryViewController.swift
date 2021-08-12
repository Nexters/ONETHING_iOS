//
//  HistoryViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HistoryViewController: BaseViewController {
    private let historyEmptyView = HistoryEmptyView()
    private let countLabel = UILabel()
    private let titleLabel = UILabel().then {
        $0.text = "내습관"
        $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
    }
    private let viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitleLabel()
        self.setupHistoryEmptyView()
        self.setupCountLabel()
        self.viewModel.requestTotalHistories()
    }
    
    override func reloadContentsIfRequired() {
        super.reloadContentsIfRequired()
        #warning("로그아웃할 때 호출됨")
    }
    
    override func clearContents() {
        super.clearContents()
        #warning("로그아웃할 때 호출됨")
    }
    
    private func setupTitleLabel() {
        self.view.addSubview(self.titleLabel)
        
        let safeArea = self.view.safeAreaLayoutGuide
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(32)
            $0.top.equalTo(safeArea).offset(54)
        }
    }
    
    private func setupHistoryEmptyView() {
        self.view.addSubview(self.historyEmptyView)
        
        self.historyEmptyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupCountLabel() {
        self.countLabel.do {
            $0.text = "3개"
            $0.textColor = .black_40
            $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 18)
            $0.isHidden = true
        }
        self.view.addSubview(self.countLabel)
        
        self.countLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(9)
        }
    }
}
