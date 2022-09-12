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
    
    private var cardView: CardView?
    private var widthOfTargetView: CGFloat?
    private var heightOfTargetView: CGFloat?
    
    private var transition: CardTransitionType = .presentation
    private var transitionDuration: Double = 1.0
    private var shrinkDuration: Double = 0.2
    
    func configureCardView(with targetView: UIView, presentable: MyHabitCellPresentable?) {
        let viewModel = HabitInfoViewModel(presentable: presentable)
        self.cardView = CardView(with: targetView, habitInfoViewModel: viewModel)
    }
    
    private func makeShrinkAnimator(for cardView: CardView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: self.shrinkDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func makeExpandContractAnimator(for cardView: CardView, in containerView: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 3))
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration - self.shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            cardView.transform = .identity
            cardView.convertToInfoView()
            containerView.layoutIfNeeded()
        }
        
        return animator
    }
    
    private func moveAndConvertToCardView(cardView: CardView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () -> ()) {
        let shrinkAnimator = self.makeShrinkAnimator(for: cardView)
        let expandContractAnimator = self.makeExpandContractAnimator(for: cardView, in: containerView, yOrigin: yOriginToMoveTo)
        
        expandContractAnimator.addCompletion { _ in
            completion()
        }
        
        if self.transition == .presentation {
            shrinkAnimator.addCompletion { _ in
                cardView.layoutIfNeeded()
                expandContractAnimator.startAnimation()
            }
            
            shrinkAnimator.startAnimation()
        }
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

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let cardView = self.cardView else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(cardView)
        
        guard let habitHistoryViewController = transitionContext.viewController(forKey: .to)
                as? HabitHistoryViewController
        else { return }
        
        containerView.addSubview(habitHistoryViewController.view)
        habitHistoryViewController.viewsAreHidden = true
        
        self.moveAndConvertToCardView(cardView: cardView, containerView: containerView, yOriginToMoveTo: 0, completion: {
            habitHistoryViewController.viewsAreHidden = false
        })
        
        transitionContext.completeTransition(true)
    }
}



