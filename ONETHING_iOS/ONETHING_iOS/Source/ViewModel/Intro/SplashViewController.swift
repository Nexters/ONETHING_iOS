//
//  SplashViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/27.
//

import Lottie
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
    }
    
    private func setupAnimation() {
        self.animationView.animation   = Animation.named("splash_screen")
        self.animationView.loopMode    = .playOnce
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.play { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet private weak var animationView: AnimationView!
    
}
