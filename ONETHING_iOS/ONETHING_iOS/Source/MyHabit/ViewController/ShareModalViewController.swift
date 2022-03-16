//
//  ShareModalViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import RxCocoa
import RxSwift
import Then
import SnapKit
import UIKit

protocol ShareModalViewControllerDataSource: AnyObject {
    func shareImage(ofShareViewController viewController: ShareModalViewController) -> UIImage?
}

final class ShareModalViewController: BaseViewController {
    
    weak var dataSource: ShareModalViewControllerDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupLayout()
    }
    
    func presentWithAnimation(fromViewController viewController: UIViewController) {
        self.dimView.alpha = 0
        self.modalView.transform = CGAffineTransform(translationX: 0, y: DeviceInfo.screenHeight)
        viewController.present(self, animated: false) {
            UIView.animate(withDuration: 0.3) {
                self.dimView.alpha = 0.7
                self.modalView.transform = .identity
            }
        }
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimView.alpha = 0
            self.modalView.transform = CGAffineTransform(translationX: 0, y: DeviceInfo.screenHeight)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }

    private func setupUI() {
        self.view.do {
            $0.backgroundColor = .clear
        }
        
        self.dimView.do {
            $0.backgroundColor = UIColor.black
            $0.alpha = 0.7
            $0.addGestureRecognizer(self.makeDimViewGestureRecognizer())
        }
        
        self.modalView.do {
            $0.delegate = self
        }
        
        self.loadingIndicatorView.do {
            $0.style = .medium
            $0.color = .white
            $0.hidesWhenStopped = true
        }
    
        self.view.addSubview(self.dimView)
        self.view.addSubview(self.modalView)
        self.view.addSubview(self.loadingIndicatorView)
    }
    
    private func setupLayout() {
        self.dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.modalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func makeDimViewGestureRecognizer() -> UITapGestureRecognizer {
        let tapGetureRecognizer = UITapGestureRecognizer()
        tapGetureRecognizer.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismissWithAnimation()
            })
            .disposed(by: self.disposeBag)
        
        return tapGetureRecognizer
    }
    
    private let disposeBag = DisposeBag()
    
    private let dimView = UIView(frame: .zero)
    private let modalView = ShareModalView(frame: .zero)
    private let loadingIndicatorView = UIActivityIndicatorView(style: .medium)

}

extension ShareModalViewController: ShareModalViewDelegate {
    
    func shareModalView(_ view: ShareModalView, didOccurEvent event: ShareModalView.ViewEvent) {
        guard let captureImage = self.dataSource?.shareImage(ofShareViewController: self) else { return }
        
        switch event {
        case .tapShareInsta:
            self.shareToInsta(withImage: captureImage)
        case .tapSaveImage:
            self.saveImage(captureImage)
        case .tapEtc:
            self.presentActivityViewController(withImage: captureImage)
        case .tapCancel:
            self.dismissWithAnimation()
        }
    }
    
    private func shareToInsta(withImage image: UIImage) {
        guard let instagramStoryURL = URL(string: "instagram-stories://share") else { return }
        guard let imageData = image.pngData()                                  else { return }
        
        if UIApplication.shared.canOpenURL(instagramStoryURL) {
            let pasteBoardItems: [String: Any] = ["com.instagram.sharedSticker.stickerImage": imageData]
            let pasteBoardOptions: [UIPasteboard.OptionsKey: Any] = [
                UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
            ]
            UIPasteboard.general.setItems([pasteBoardItems], options: pasteBoardOptions)
            UIApplication.shared.open(instagramStoryURL, options: [:], completionHandler: nil)
        }
    }
    
    private func saveImage(_ image: UIImage) {
        self.loadingIndicatorView.startAnimating()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWith:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWith error: NSError?, contextInfo context: UnsafeMutableRawPointer?) {
        self.loadingIndicatorView.stopAnimating()
    }

    private func presentActivityViewController(withImage image: UIImage) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
}
