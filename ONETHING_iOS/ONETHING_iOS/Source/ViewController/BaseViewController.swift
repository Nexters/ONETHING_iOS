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
    
    // Override 해서 각 뷰들 API 호출 - User 정보나 뭔가 새롭게 Login 되었을 때 호출
    func reloadContentsIfRequired() { }
    
    // Override 해서 각 뷰들 UI Clear - Logout 할 때 호출됨
    func clearContents() { }
    
    private func setupBackground() {
        self.view.backgroundColor = .white
    }

}
