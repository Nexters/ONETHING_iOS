//
//  BackgroundDimView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class BackgroundDimView: UIView {
    private var tapGesture: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .black
        self.alpha = 0
        self.isHidden = true
    }
    
    func addTapGestureRecognizer(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.tapGesture = tapGestureRecognizer
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeTapGestureRecognizer() {
        guard let tapGesture = self.tapGesture else {
            return
        }

        self.removeGestureRecognizer(tapGesture)
        self.tapGesture = nil
    }
    
    static var completedAlpha: CGFloat {
        return 0.6
    }
}
