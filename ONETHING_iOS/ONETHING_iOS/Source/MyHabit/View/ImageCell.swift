//
//  ImageCell.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 05/01/2023.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with image: UIImage?) {
        self.imageView.alpha = 0
        self.imageView.image = image
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1
        }
    }
}
