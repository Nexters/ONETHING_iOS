//
//  PenaltyTextableView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

final class PenaltyTextableView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.text = ""
        self.placeholderLabel.text = "내가 또 미루면 사람이 아니다"
    }
  
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
}
