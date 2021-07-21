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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.setupImageView()
        self.setupCircleCheckView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.clipsToBounds = false
        self.circleCheckView.isHidden = true
    }

    private func setupImageView() {
        self.mainImageView.contentMode = .scaleAspectFit
        self.mainImageView.image = UIImage(named: "rabbit_none")
        
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
    
    func hideCheckView() {
        self.circleCheckView.isHidden = true
    }
    
    func showCheckView() {
        self.circleCheckView.isHidden = false
    }
}
