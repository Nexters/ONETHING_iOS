//
//  MyHabitInfoView.swift
//  ONETHING_iOS
//
//  Created by 김도형 on 12/09/2022.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyHabitInfoViewDelegate: AnyObject {
    func myHabitInfoView(_ view: MyHabitInfoView, didOccur event: MyHabitInfoView.ViewEvent)
}

extension MyHabitInfoView {
    enum ViewEvent {
        case backButton
        case share
        case delete
    }
}

final class MyHabitInfoView: UIView {
    weak var delegate: MyHabitInfoViewDelegate?
    
    private let backButton = UIButton()
    private let deleteButton = UIButton()
    private let shareButton = UIButton()
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()
    private let resultDesciptionLabel = UILabel()
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupLayout()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with habitInfoViewModel: HabitInfoViewModel) {
        self.titleLabel.text = habitInfoViewModel.titleText
        self.resultLabel.textColor = habitInfoViewModel.resultLabelColor
        self.resultLabel.text = habitInfoViewModel.resultText
        self.resultDesciptionLabel.text = habitInfoViewModel.resultDesciptionText
    }
    
    private func setupUI() {
        self.backgroundColor = .black_100
        
        self.backButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        self.deleteButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        self.shareButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(named: "share_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        self.titleLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .bold), size: 26)
            $0.textColor = .white
        }
        
        self.resultLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .medium), size: 12)
            $0.textColor = .red_default
        }
        
        self.resultDesciptionLabel.do {
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 12)
            $0.textColor = .black_60
        }
        
        self.addSubview(self.backButton)
        self.addSubview(self.deleteButton)
        self.addSubview(self.shareButton)
        self.addSubview(self.titleLabel)
        self.addSubview(self.resultLabel)
        self.addSubview(self.resultDesciptionLabel)
    }
    
    private func setupLayout() {
        self.backButton.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.leading.equalTo(32)
            
            let topConstant = UIApplication.shared.hasTopNotch ? 64.0 : 54.0
            make.top.equalTo(topConstant)
        })
        
        self.deleteButton.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(self.shareButton.snp.leading).offset(-14)
            
            make.top.equalTo(self.backButton)
        })
        
        self.shareButton.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(-32)
            make.top.equalTo(self.backButton)
        })
        
        self.titleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.backButton.snp.leading).offset(3)
            make.top.equalTo(self.backButton.snp.bottom).offset(23)
        })
        
        self.resultLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.backButton.snp.leading).offset(3)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-23)
        })
        
        self.resultDesciptionLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self.resultLabel.snp.trailing).offset(10)
            make.centerY.equalTo(self.resultLabel)
        })
    }
    
    private func bindUI() {
        self.backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.myHabitInfoView(owner, didOccur: .backButton)
            })
            .disposed(by: self.disposeBag)
        
        self.shareButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.myHabitInfoView(owner, didOccur: .share)
            })
            .disposed(by: self.disposeBag)
        
        self.deleteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delegate?.myHabitInfoView(owner, didOccur: .delete)
            })
            .disposed(by: self.disposeBag)
    }
}
