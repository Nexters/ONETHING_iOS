//
//  SplashViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/27.
//

import Lottie
import UIKit

protocol SplashViewControllerDelegate: AnyObject {
    func splashViewController(_ viewController: SplashViewController, didOccur event: SplashViewController.Event)
}

final class SplashViewController: BaseViewController {
    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAnimationView()
        self.waitAndDismiss()
    }
    
    private func setupAnimationView() {
        self.animationView.do {
            $0.animation   = Animation.named("splash_screen")
            $0.loopMode    = .playOnce
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func playAnimation() {
        self.animationView.play(completion: { _ in
            self.dismissViewController()
        })
    }
    
    private func waitAndDismiss(delayTime: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: { [weak self] in
            self?.dismissViewController()
        })
    }
    
    private func dismissViewController() {
        self.backgroundView.hideCrossDissolve {
            self.delegate?.splashViewController(self, didOccur: .splashAnimationDidFinish)
        }
    }
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var animationView: AnimationView!
}

extension SplashViewController {
    enum Event {
        case splashAnimationDidFinish
    }
}
