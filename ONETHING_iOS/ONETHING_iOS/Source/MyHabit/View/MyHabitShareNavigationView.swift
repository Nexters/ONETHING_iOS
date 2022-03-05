//
//  MyHabitShareNavigationView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2022/03/05.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

protocol MyHabitShareNavigationViewDelegate: AnyObject {
    func myHabitShareNavigationView(_ view: MyHabitShareNavigationView, didOccur event: MyHabitShareNavigationView.ViewEvent)
}

class MyHabitShareNavigationView: UIView {
    
    weak var delegate: MyHabitShareNavigationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupLayout()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.titleLabel.do {
            $0.textAlignment = .center
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 18)
            $0.text = "공유하기"
        }
        
        self.closeButton.do {
            $0.backgroundColor = .clear
            $0.setImage(UIImage(named: "x_icon"), for: .normal)
        }
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.closeButton)
    }
    
    private func setupLayout() {
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    private func bindUI() {
        self.closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                self.delegate?.myHabitShareNavigationView(owner, didOccur: .closeButton)
            })
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel(frame: .zero)
    private let closeButton = UIButton(frame: .zero)
    
}

extension MyHabitShareNavigationView {
    
    enum ViewEvent {
        case closeButton
    }
    
}
