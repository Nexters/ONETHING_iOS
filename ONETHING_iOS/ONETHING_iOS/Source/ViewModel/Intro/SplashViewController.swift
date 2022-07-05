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

final class SplashViewController: UIViewController {
    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
    }
    
    private func setupAnimation() {
        self.animationView.animation   = Animation.named("splash_screen")
        self.animationView.loopMode    = .playOnce
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.play { _ in
            self.delegate?.splashViewController(self, didOccur: .splashAnimationDidFinish)
        }
    }
    
    @IBOutlet private weak var animationView: AnimationView!
}

extension SplashViewController {
    enum Event {
        case splashAnimationDidFinish
    }
}
