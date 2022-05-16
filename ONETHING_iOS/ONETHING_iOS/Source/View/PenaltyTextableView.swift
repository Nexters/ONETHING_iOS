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
        
        self.textField.textableView = self
        self.textField.text = ""
        self.placeholderLabel.text = ""
    }
  
    @IBOutlet weak var textField: DelayPenaltyTextField!
    @IBOutlet weak var placeholderLabel: UILabel!
}

final class DelayPenaltyTextField: UITextField {
    weak var textableView: PenaltyTextableView?
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    func representIsInvalidIfIsFirst() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.setSelectedRangeFromBeginToEnd()
            self.animateShake()
        })
    }
    
    func representIsInvalidIfIsNotFirst() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animateShake()
        })
    }
    
    private func setSelectedRangeFromBeginToEnd() {
        self.selectedTextRange = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
    }
    
    private func animateShake() {
        self.text != "" ? self.animateShaking() : self.textableView?.placeholderLabel.animateShaking()
    }
}
