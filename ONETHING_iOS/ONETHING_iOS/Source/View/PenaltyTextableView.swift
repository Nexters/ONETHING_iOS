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
  
    @IBOutlet weak var textField: DelayPenaltyTextField!
    @IBOutlet weak var placeholderLabel: UILabel!
}

final class DelayPenaltyTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
