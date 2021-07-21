//
//  CompleteButton.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/18.
//

import UIKit

final class CompleteButton: UIButton {
    private weak var parentViewController: UIViewController?
    
    init(frame: CGRect = .zero, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.addTarget(self, action: #selector(self.completeButtonDidTouch(button:)), for: .touchUpInside)
        self.setTitle("저장하기", for: .normal)
        self.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 20)
        self.backgroundColor = .black_100
    }
    
    @objc private func completeButtonDidTouch(button: UIButton?) {
        self.dismiss()
    }
    
    private func dismiss() {
        guard let parentViewController = self.parentViewController else { return }
        
        parentViewController.navigationController?.popViewController(animated: true)
    }
}
