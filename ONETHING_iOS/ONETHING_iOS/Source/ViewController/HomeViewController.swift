//
//  ViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    private let mainScrollView = UIScrollView()
    private let homeUpperView = HomeUpperView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainScrollView()
        configureHomeUpperView()
    }
    
    private func configureMainScrollView() {
        self.view.addSubview(self.mainScrollView)
        
        mainScrollView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    private func configureHomeUpperView() {
        self.mainScrollView.addSubview(self.homeUpperView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        homeUpperView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeArea).inset(34)
            $0.top.equalTo(safeArea).inset(52)
            $0.height.equalTo(homeUpperView.snp.width).dividedBy(2.3)
        }
    }
    
    
}

