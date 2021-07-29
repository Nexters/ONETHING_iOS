//
//  HistoryViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HistoryViewController: BaseViewController {
    private let historyEmptyView = HistoryEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHistoryEmptyView()
    }
    
    private func setupHistoryEmptyView() {
        self.view.addSubview(self.historyEmptyView)
        
        self.historyEmptyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
