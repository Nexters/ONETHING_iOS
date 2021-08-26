//
//  PenaltyInfoView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

protocol PenaltyInfoViewModable {
    var penaltyWriteCountText: String { get }
}

final class PenaltyInfoView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCount(with viewModel: PenaltyInfoViewModable) {
        self.countLabel.text = viewModel.penaltyWriteCountText
        self.countLabel.sizeToFit()
    }
    
    func update(sentence: String?) {
        self.sentenceLabel.text = sentence
    }
    
    @IBOutlet weak var countBoxView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet private weak var sentenceLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
}
