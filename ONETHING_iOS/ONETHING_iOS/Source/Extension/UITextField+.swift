//
//  UITextField+.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 09/05/2022.
//

import UIKit

extension UITextField {
    func trimWhitSpacesAndNewLines() {
        self.text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
