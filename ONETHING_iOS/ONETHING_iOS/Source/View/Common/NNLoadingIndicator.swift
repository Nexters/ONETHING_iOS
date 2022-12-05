//
//  NNLoadingIndicatorView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 08/08/2022.
//

import UIKit

final class NNLoadingIndicator: UIActivityIndicatorView {
    private let defaultColor: UIColor = .red_default
    private var delayTimer: Timer?
    
    
    init() {
        super.init(style: .large)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.color = self.defaultColor
    }
    
    func startAfterTime(_ delayTime: TimeInterval = 0.5) {
        self.delayTimer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.startAnimating()
            
            self.delayTimer?.invalidate()
            self.delayTimer = nil
        })
    }
    
    func stop() {
        self.stopAnimating()
        self.delayTimer?.invalidate()
        self.delayTimer = nil
    }
}
