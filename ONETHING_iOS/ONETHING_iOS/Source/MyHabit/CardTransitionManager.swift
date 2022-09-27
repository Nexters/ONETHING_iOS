//
//  MyHabitTransitionManager.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 07/09/2022.
//

import UIKit

final class CardTransitionManager: NSObject {
    enum CardTransitionType {
        case presentation
        case dismissal
    }
    
    var cardView: CardView?
    private var widthOfTargetView: CGFloat?
    private var heightOfTargetView: CGFloat?
    
    private var transition: CardTransitionType = .presentation
    private var transitionDuration: Double = 1.0
    private var shrinkDuration: Double = 0.2
    
    weak var targetView: UIView?
    weak var presentingViewController: UIViewController?
    
    private func makeShrinkAnimator(for cardView: CardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: self.shrinkDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func makeExpandContractAnimator(for cardView: CardView, in containerView: UIView) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration - self.shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            cardView.transform = .identity
            self.transition == .presentation ? cardView.convertToInfoView() : cardView.convertToOriginal()
            containerView.layoutIfNeeded()
        }
        
        return animator
    }
    
    private func moveAndConvertToCardView(cardView: CardView, containerView: UIView, completion: @escaping () -> ()) {
        let shrinkAnimator = self.makeShrinkAnimator(for: cardView)
        let expandContractAnimator = self.makeExpandContractAnimator(for: cardView, in: containerView)
        
        expandContractAnimator.addCompletion { _ in
            completion()
        }
        
        switch self.transition {
        case .presentation:
            shrinkAnimator.addCompletion { _ in
                cardView.layoutIfNeeded()
                expandContractAnimator.startAnimation()
            }
            
            shrinkAnimator.startAnimation()
        case .dismissal:
            cardView.layoutIfNeeded()
            expandContractAnimator.startAnimation()
        }
    }
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let cardView = self.cardView else { return }
        
        switch self.transition {
        case .presentation:
            let containerView = transitionContext.containerView
            containerView.addSubview(cardView)
            
            guard let habitHistoryViewController = transitionContext.viewController(forKey: .to)
                    as? HabitHistoryViewController
            else { return }
            
            containerView.addSubview(habitHistoryViewController.view)
            habitHistoryViewController.viewsAreHidden = true
            self.targetView?.isHidden = true
            self.moveAndConvertToCardView(cardView: cardView, containerView: containerView, completion: {
                self.targetView?.isHidden = false
                habitHistoryViewController.viewsAreHidden = false
                cardView.layoutIfNeeded()
                transitionContext.completeTransition(true)
            })
        case .dismissal:
            let containerView = transitionContext.containerView
            
            guard let habitHistoryViewController = transitionContext.viewController(forKey: .from)
                    as? HabitHistoryViewController
            else { return }
            
            habitHistoryViewController.viewsAreHidden = true
            cardView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: cardView.originalFrame.height)
            self.targetView?.isHidden = true
            self.moveAndConvertToCardView(cardView: cardView, containerView: containerView, completion: {
                self.targetView?.isHidden = false
                self.targetView = nil
                self.cardView = nil
                
                self.presentingViewController = transitionContext.viewController(forKey: .to)
                self.presentingViewController?.beginAppearanceTransition(true, animated: true)
                transitionContext.completeTransition(true)
            })
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.presentingViewController?.endAppearanceTransition()
        self.presentingViewController = nil
    }
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition = .dismissal
        return self
    }
}
