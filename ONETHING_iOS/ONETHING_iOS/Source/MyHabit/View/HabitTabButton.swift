//
//  HabitTabButton.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 04/01/2023.
//

import UIKit

final class HabitTabButton: UIButton {
    private var normalImage: UIImage?
    private var selectedImage: UIImage?
    
    private let deactiveColor: UIColor = .black_20
    private let activeColor: UIColor = .black_100
    
    override var isSelected: Bool {
        didSet {
            self.updateUI()
        }
    }
    
    lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.deactiveColor
        return bottomLine
    }()
    
    init(normalImage: UIImage?, selectedImage: UIImage?) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        
        super.init(frame: .zero)
        
        self.setupUI()
        self.setupLayout()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.setImage(self.normalImage, for: .normal)
        self.setImage(self.selectedImage, for: .selected)
        self.imageView?.contentMode = .scaleAspectFit
        
        self.addSubview(self.bottomLine)
    }
    
    private func setupLayout() {
        self.bottomLine.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        })
    }
    
    private func updateUI() {
        self.bottomLine.backgroundColor = self.isSelected ? self.activeColor : self.deactiveColor
    }
}
