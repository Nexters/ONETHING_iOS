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
        self.placeholderLabel.text = "제발!"
    }
  
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
}
