//
//  ShareModalView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/09.
//

import Then
import SnapKit
import RxCocoa
import RxSwift
import UIKit

protocol ShareModalViewDelegate: AnyObject {
    func shareModalView(_ view: ShareModalView, didOccurEvent event: ShareModalView.ViewEvent)
}

final class ShareModalView: UIView {
    
    weak var delegate: ShareModalViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCornerRadius(directions: [.topLeft, .topRight], radius: 10)
    }
    
    private func setupUI() {
        self.do {
            $0.backgroundColor = .white
        }
        
        self.titleLabel.do {
            $0.text = "공유"
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
        }
        
        self.shareButtonStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.spacing = 26
        }
        
        self.instaShareView.do {
            $0.shareCategory = .instagram
            $0.addGestureRecognizer(self.makeShareGestureRecognizer(shareType: .instagram))
        }
        
        self.saveImageView.do {
            $0.shareCategory = .saveImage
            $0.addGestureRecognizer(self.makeShareGestureRecognizer(shareType: .saveImage))
        }
        
        self.etcView.do {
            $0.shareCategory = .etc
            $0.addGestureRecognizer(self.makeShareGestureRecognizer(shareType: .etc))
        }
        
        self.borderView.do {
            $0.backgroundColor = .black_20
        }
        
        self.cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black_60, for: .normal)
            $0.titleLabel?.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 20)
        }
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.shareButtonStackView)
        self.shareButtonStackView.addArrangedSubview(self.instaShareView)
        self.shareButtonStackView.addArrangedSubview(self.saveImageView)
        self.shareButtonStackView.addArrangedSubview(self.etcView)
        self.addSubview(self.borderView)
        self.addSubview(self.cancelButton)
    }
    
    private func setupLayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
        }
                
        self.shareButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
        }
        
        self.borderView.snp.makeConstraints { make in
            make.top.equalTo(self.shareButtonStackView.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self.borderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(DeviceInfo.safeAreaBottomInset)
        }
    }
    
    private func bindUI() {
        self.cancelButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.shareModalView(owner, didOccurEvent: .tapCancel)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func makeShareGestureRecognizer(shareType: ShareSNSCategory) -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                switch shareType {
                case .instagram:
                    owner.delegate?.shareModalView(owner, didOccurEvent: .tapShareInsta)
                case .saveImage:
                    owner.delegate?.shareModalView(owner, didOccurEvent: .tapSaveImage)
                case .etc:
                    owner.delegate?.shareModalView(owner, didOccurEvent: .tapEtc)
                }
            })
            .disposed(by: self.disposeBag)
        return tapGestureRecognizer
    }
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel(frame: .zero)
    private let shareButtonStackView = UIStackView()
    private let instaShareView = ShareItemView(frame: .zero)
    private let saveImageView = ShareItemView(frame: .zero)
    private let etcView = ShareItemView(frame: .zero)
    private let borderView = UIView(frame: .zero)
    private let cancelButton = UIButton(frame: .zero)

}

extension ShareModalView {
    
    enum ViewEvent {
        case tapCancel
        case tapShareInsta
        case tapSaveImage
        case tapEtc
    }
    
}
