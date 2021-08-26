//
//  PenaltyInfoView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

final class PenaltyInfoView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCount(with viewModel: HabitEditViewModel) {
        self.countLabel.text = viewModel.penaltyWriteCountText
        self.countLabel.sizeToFit()
    }
    
    @IBOutlet weak var countBoxView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!
}
