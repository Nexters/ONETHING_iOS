//
//  HeightRatioController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/21.
//

import UIKit

final class HeightRatioPresentationController: UIPresentationController {
    private var heightRatio: CGFloat
    private var yRatio: CGFloat
    
    init(heightRatio: CGFloat, presentedViewController: UIViewController, presenting: UIViewController?) {
        self.heightRatio = heightRatio
        self.yRatio = 1 - heightRatio
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let realCotainerView = containerView else { return .null }
        return CGRect(x: realCotainerView.frame.origin.x,
                      y: realCotainerView.bounds.height * yRatio,
                      width: realCotainerView.bounds.width,
                      height: realCotainerView.bounds.height * (self.heightRatio + 0.1))
    }
}
