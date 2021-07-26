//
//  HabitStampCell.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class HabitStampCell: UICollectionViewCell {
    private let circleCheckView = CircleView()
    private let mainImageView = UIImageView()
    private(set) var isLocked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.setupMainImageView()
        self.setupCircleCheckView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.clipsToBounds = false
        self.circleCheckView.isHidden = true
    }

    private func setupMainImageView() {
        self.mainImageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(self.mainImageView)
        self.mainImageView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCircleCheckView() {
        self.circleCheckView.layer.borderWidth = 2
        self.circleCheckView.layer.borderColor = UIColor.red_2.cgColor
        
        self.addSubview(self.circleCheckView)
        self.circleCheckView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(-9)
        }
    }
    
    func update(stampImage: UIImage) {
        self.mainImageView.image = stampImage
    }
    
    func set(isLocked: Bool) {
        self.isLocked = isLocked
    }
    
    func hideCheckView() {
        self.circleCheckView.isHidden = true
    }
    
    func showCheckView() {
        self.circleCheckView.isHidden = false
    }
}
