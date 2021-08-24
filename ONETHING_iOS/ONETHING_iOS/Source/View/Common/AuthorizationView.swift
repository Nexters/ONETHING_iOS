//
//  AuthorizationView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/24.
//

import RxCocoa
import RxSwift
import UIKit

class AuthorizationView: UIView {
    
    typealias Handler = () -> Void

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTitleLabel()
        self.bindButtons()
    }
    
    func configure(_ mediaType: MediaType, confirmHandler: Handler? = nil) {
        self.confirmHandler = confirmHandler
        
        self.authorizationImageView.image = mediaType.image
        self.authorizationLabel.text = mediaType.authorizationTitle
        self.authorizationDescriptionLabel.text = mediaType.authorizationDescription
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.showCrossDissolve()
    }
    
    private func setupTitleLabel() {
        let title = "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요"
        let attributeText = NSMutableAttributedString(string: title)
        
        guard let subRange = title.range(of: "아래와 같은 권한을 허용해주세요") else { return }
        attributeText.addAttribute(.foregroundColor, value: UIColor.red_default, range: subRange)
        self.titleLabel.attributedText = attributeText
    }
    
    private func bindButtons() {
        self.confirmButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.hideCrossDissolve { [weak self] in
                self?.confirmHandler?()
                self?.removeFromSuperview()
            }
        }).disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.hideCrossDissolve { [weak self] in
                self?.removeFromSuperview()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private var confirmHandler: Handler?
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorizationImageView: UIImageView!
    @IBOutlet private weak var authorizationLabel: UILabel!
    @IBOutlet private weak var authorizationDescriptionLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
}

enum MediaType {
    case camera
    case gallery
    
    var image: UIImage? {
        switch self {
        case .camera:  return #imageLiteral(resourceName: "rabbit_photo")
        case .gallery: return #imageLiteral(resourceName: "rabbit_gallery")
        }
    }
    
    var authorizationTitle: String {
        switch self {
        case .camera:  return "카메라"
        case .gallery: return "사진"
        }
    }
    
    var authorizationDescription: String {
        switch self {
        case .camera:  return "사진 촬영하기"
        case .gallery: return "사진 가져오기"
        }
    }
}
