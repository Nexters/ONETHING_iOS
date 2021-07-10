//
//  BaseViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/10.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
    }
    
    private func setupBackground() {
        self.view.backgroundColor = .white
    }

}
