//
//  DelayPopupView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/23.
//

import UIKit

import RxSwift
import RxCocoa

protocol DelayPopupViewDelegate: AnyObject {
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView)
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView)
}

final class DelayPopupView: UIView, ShakeView {
    let guideLabel = UILabel().then {
        $0.text = "미룸벌칙을 완료해야만 서비스를 이용할 수 있어요!"
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 12)
    }
    
    weak var delegate: DelayPopupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubTitleLabel()
        self.bindButtons()
    }
    
    private func setupSubTitleLabel() {
        self.subTitleLabel.text = "미룸벌칙을 완료하고\n다시 열심히 지속해봐요!"
    }
    
    private func bindButtons() {
        self.giveUpButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.delayPopupViewDidTapGiveUpButton(self)
        }).disposed(by: self.disposeBag)
        
        self.passPenaltyButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.delayPopupViewDidTapPassPenaltyButton(self)
        }).disposed(by: self.disposeBag)
    }
    
    func configure(with viewModel: HomeViewModel) {
        self.titleLabel.attributedText = viewModel.titleTextOfDelayPopupView
        self.remainedDelayCountLabel.text = viewModel.remainedDelayTextOfDelayPopupView
    }
    
    func show(in targetController: UIViewController, completion: (() -> Void)? = nil) {
        targetController.view.addSubview(self)
        self.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        self.setupGuideLabel(with: targetController)
        self.showCrossDissolve(completion: {
            completion?()
        })
    }
    
    private func setupGuideLabel(with targetController: UIViewController) {
        targetController.view.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func removeFromSuperView(_ duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        self.guideLabel.removeFromSuperview()
        
        self.hideCrossDissolve(duration, completion: {
            self.removeFromSuperview()
            completion?()
        })
    }
    
    private let disposeBag = DisposeBag()
 
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var remainedDelayCountLabel: UILabel!
    
    @IBOutlet private weak var giveUpButton: UIButton!
    @IBOutlet private weak var passPenaltyButton: UIButton!
}
