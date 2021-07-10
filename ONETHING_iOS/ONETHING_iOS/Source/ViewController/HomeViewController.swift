//
//  ViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    private let homeUpperView = HomeUpperView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeUpperView()
    }
    
    private func configureHomeUpperView() {
        self.view.addSubview(homeUpperView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        homeUpperView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(34)
            $0.top.equalTo(safeArea).inset(52)
            $0.height.equalTo(homeUpperView.snp.width).dividedBy(2.3)
        }
    }
}

