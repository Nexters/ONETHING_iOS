//
//  LargeTouchableButton.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/12.
//

import UIKit

final class LargeTouchableButton: UIButton {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return self.incresedTwiceTouchArea.contains(point)
  }

  private var incresedTwiceTouchArea: CGRect {
    let x = self.bounds.origin.x - self.bounds.size.width / 2.0
    let y = self.bounds.origin.y - self.bounds.size.height / 2.0
    let width = self.bounds.size.width * 2
    let height = self.bounds.size.height * 2
    return CGRect(x: x, y: y, width: width, height: height)
  }
}
