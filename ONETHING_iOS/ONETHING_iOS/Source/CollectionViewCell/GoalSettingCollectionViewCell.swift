//
//  GoalSettingCollectionViewCell.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/13.
//

import UIKit

class GoalSettingCollectionViewCell: UICollectionViewCell {

    func configure(_ goalText: String) {
        self.goalLabel.text = goalText
    }
    
    @IBOutlet private weak var goalLabel: UILabel!
    
}
