//
//  NotReadyPopupView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import RxCocoa
import RxSwift
import UIKit

class CustomPopupView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = "서비스를\n준비중이에요!"
        self.bindTapGesture()
    }
    
    func show(in targetController: UIViewController) {
        targetController.view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.showCrossDissolve()
    }
    
    func configure(title: String?, image: UIImage?) {
        self.titleLabel.text = title
        self.imageView.image = image
    }
    
    func configure(attributedText: NSAttributedString?, numberText: String?, image: UIImage?) {
        self.titleLabel.attributedText = attributedText
        self.numberLabel.text = numberText
        self.imageView.image = image
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.observeOnMain(onNext: { [weak self] _ in
            self?.hideCrossDissolve()
        }).disposed(by: self.disposeBag)
        self.dimView.addGestureRecognizer(tapGesture)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var dimView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
}
