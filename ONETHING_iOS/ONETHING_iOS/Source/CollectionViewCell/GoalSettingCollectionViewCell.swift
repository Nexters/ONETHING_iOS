//
//  GoalSettingCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

class GoalSettingCollectionViewCell: UICollectionViewCell {
    
    func configure(_ recommendHabbitModel: RecommendHabbitModel) {
        self.recommendHabbitModel = recommendHabbitModel
        
        self.titleLabel.text = recommendHabbitModel.title
        self.cornerRadius = recommendHabbitModel.onethingShape.cornerRadius
        self.backgroundColor = recommendHabbitModel.onethingColor
    }
    
    private var recommendHabbitModel: RecommendHabbitModel?
    
    @IBOutlet private weak var titleLabel: UILabel!
    
}
