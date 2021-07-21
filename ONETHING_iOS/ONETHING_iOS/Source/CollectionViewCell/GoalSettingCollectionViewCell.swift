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
        self.setRandomeColor()
    }

    func setup(_ goalText: String?) {
        self.goalLabel.text = goalText
    }
    
    private func setRandomeColor() {
        let randomRed   = Int((0...255).randomElement() ?? 0)
        let randomGreen = Int((0...255).randomElement() ?? 0)
        let randomBlue  = Int((0...255).randomElement() ?? 0)
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue)
    }
    
    @IBOutlet private weak var goalLabel: UILabel!
    
}
