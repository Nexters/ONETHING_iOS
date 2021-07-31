//
//  GoalSettingCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

class GoalSettingCollectionViewCell: UICollectionViewCell {
    
    func configure(_ recommendHabbitModel: RecommendHabitModel) {
        self.recommendHabbitModel = recommendHabbitModel
        
        self.titleLabel.text = recommendHabbitModel.title
        self.cornerRadius = recommendHabbitModel.onethingShape.cornerRadius
        self.backgroundColor = recommendHabbitModel.onethingColor
    }
    
    private var recommendHabbitModel: RecommendHabitModel?
    
    @IBOutlet private weak var titleLabel: UILabel!
    
}
