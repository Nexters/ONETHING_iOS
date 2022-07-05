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
        self.playAnimation()
    }
    
    private func setupAnimationView() {
        self.animationView.animation   = Animation.named("splash_screen")
        self.animationView.loopMode    = .playOnce
        self.animationView.contentMode = .scaleAspectFit
    }
    
    private func playAnimation() {
        self.animationView.play(completion: self.handleWhenAnimationFinished)
    }
    
    private func handleWhenAnimationFinished(_ result: Bool) {
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
