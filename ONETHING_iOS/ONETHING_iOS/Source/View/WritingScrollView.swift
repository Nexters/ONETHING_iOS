//
//  WritingScrollView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 09/05/2022.
//

import UIKit

final class WritingPenaltyScrollView: UIScrollView {
    var heightConstraintOfScrollViewAtFirst: NSLayoutConstraint?
    var bottomConstraintOfScrollViewIfLarge: NSLayoutConstraint?
    var heightConstraintOfScrollViewWhenKeyboardShow: NSLayoutConstraint?
    var keyboardFrame: CGRect?
    
    func activeHeightConstraintOfScrollViewForSmall() {
        self.heightConstraintOfScrollViewAtFirst?.isActive = true
        self.bottomConstraintOfScrollViewIfLarge?.isActive = false
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = false
    }
    
    func activeBottomConstraintOfScrollViewForBig() {
        self.bottomConstraintOfScrollViewIfLarge?.isActive = true
        self.heightConstraintOfScrollViewAtFirst?.isActive = false
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = false
    }
    
    func activeHeightConstraintOfScrollViewWhenKeyboardShow() {
        self.heightConstraintOfScrollViewWhenKeyboardShow?.isActive = true
        self.heightConstraintOfScrollViewAtFirst?.isActive = false
        self.bottomConstraintOfScrollViewIfLarge?.isActive = false
    }
    
    func updateScrollViewWhenKeyboardShowIfNeeded() {
        guard let keyboardFrame = self.keyboardFrame,
              self.isScrollViewHeightHigherThanKeyboardThreshold(with: keyboardFrame)
        else { return }
        
        let heightConstant = abs(self.frame.minY - keyboardFrame.minY) - 10.0
        self.heightConstraintOfScrollViewWhenKeyboardShow = self.heightAnchor.constraint(equalToConstant: heightConstant)
        self.activeHeightConstraintOfScrollViewWhenKeyboardShow()
    }
    
    private func isScrollViewHeightHigherThanKeyboardThreshold(with keyboardFrame: CGRect) -> Bool {
        let scrollViewViewHeight = self.frame.height
        let keyBoardThreshold = abs(self.frame.minY - keyboardFrame.minY)
        return scrollViewViewHeight > keyBoardThreshold
    }
}
