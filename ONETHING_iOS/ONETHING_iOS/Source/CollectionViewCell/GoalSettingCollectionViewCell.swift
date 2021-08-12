//
//  GoalSettingCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

class GoalSettingCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeShadow()
    }
    
    func configure(_ recommendHabbitModel: RecommendHabitModel) {
        self.recommendHabbitModel = recommendHabbitModel
        
        self.titleLabel.text = recommendHabbitModel.title
        self.cornerRadius = recommendHabbitModel.onethingShape.cornerRadius
        self.backgroundColor = recommendHabbitModel.onethingColor
    }
    
    private func makeShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 4
        self.layer.rasterizationScale = 1.0
    }
    
    private var recommendHabbitModel: RecommendHabitModel?
    
    @IBOutlet private weak var titleLabel: UILabel!
    
}
