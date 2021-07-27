//
//  RightSwipeRecognizerView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/27.
//

import UIKit

import Then

final class RightSwipeGestureRecognizerView: UIView {
    weak var parentViewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupRightSwipeRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupRightSwipeRecognizer() {
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe)).then {
            $0.direction = .right
        }
        
        self.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    @objc private func didSwipe() {
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
}
