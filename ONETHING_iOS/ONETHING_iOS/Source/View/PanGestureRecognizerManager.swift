//
//  RightSwipeRecognizerView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/27.
//

import UIKit

import Then

final class PanGestureRecognizerManager {
    enum Direction {
        case left
        case right
        case up
        case down
        
        func isCorrectDirection(with panGesture: UIPanGestureRecognizer, view: UIView) -> Bool {
            switch self {
                case .left:
                    return panGesture.velocity(in: view).x < 0
                case .right:
                    return panGesture.velocity(in: view).x > 0
                case .up:
                    return panGesture.velocity(in: view).y < 0
                case .down:
                    return panGesture.velocity(in: view).y > 0
            }
        }
    }
    
    private weak var view: UIView?
    var panGestureAction: ((UIPanGestureRecognizer) -> Void)?
    private(set) var direction: Direction
    
    init(view: UIView, direction: Direction) {
        self.view = view
        self.direction = direction
        self.setupPanGesture()
    }
    
    private func setupPanGesture() {
        guard let view = self.view else { return }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureDidTouch(sender:)))
        panGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureDidTouch(sender panGestureRecognizer: UIPanGestureRecognizer) {
        guard let view = panGestureRecognizer.view else { return }
        guard self.direction.isCorrectDirection(with: panGestureRecognizer, view: view) else { return }
        
        self.panGestureAction?(panGestureRecognizer)
    }
    
    func changeCenterDuring(panGesture: UIPanGestureRecognizer, view: UIView?) {
        guard let view = view else { return }
        
        let translation = panGesture.translation(in: view.superview)
        var willChangedValue: CGFloat
        switch self.direction {
            case .left, .right:
                willChangedValue = view.center.x + translation.x
            case .up, .down:
                willChangedValue = view.center.y + translation.y
        }
        var newCenter: CGPoint
        switch self.direction {
            case .left, .right:
                newCenter = CGPoint(x: willChangedValue, y: view.center.y)
            case .up, .down:
                newCenter = CGPoint(x: view.center.x, y: willChangedValue)
        }
        
        view.center = newCenter
        panGesture.setTranslation(CGPoint.zero, in: view)
    }
}
