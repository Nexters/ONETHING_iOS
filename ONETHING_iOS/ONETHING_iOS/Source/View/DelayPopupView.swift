//
//  DelayPopupView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/23.
//

import UIKit

import RxSwift
import RxCocoa

protocol ShakeView: UIView {
    func animateShaking()
}

extension ShakeView {
    func animateShaking() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}

protocol DelayPopupViewDelegate: AnyObject {
    func delayPopupViewDidTapGiveUpButton(_ delayPopupView: DelayPopupView)
    func delayPopupViewDidTapPassPenaltyButton(_ delayPopupView: DelayPopupView)
}

final class DelayPopupView: UIView, ShakeView {
    private let guideLabel = UILabel().then {
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
    
    func configure(with viewModel: HomeViewModel) {
        self.titleLabel.text = viewModel.titleTextOfDelayPopupView
        
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
    
    func hide(_ duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        self.guideLabel.removeFromSuperview()
        
        self.hideCrossDissolve(duration, completion: {
            self.removeFromSuperview()
            completion?()
        })
    }
    
    private func bindButtons() {
        self.giveUpButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            guard let confirmPopupView: ConfirmPopupView = UIView.createFromNib() else { return }
            
            let titleText = self.titleTextOfConfirmPopupView
            confirmPopupView.configure(titleText, confirmHandler: {
                self.hide(0.1, completion: {
                    self.delegate?.delayPopupViewDidTapGiveUpButton(self)
                })
            })
            confirmPopupView.show(in: self)
        }).disposed(by: self.disposeBag)
        
        self.passPenaltyButton.rx.tap.observeOnMain(onNext: {
            self.delegate?.delayPopupViewDidTapPassPenaltyButton(self)
        }).disposed(by: self.disposeBag)
    }
    
    private var titleTextOfConfirmPopupView: NSMutableAttributedString? {
        guard let pretendardFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 15)
        else { return nil }
        
        let titleText = "열심히 달려온\n지금의 습관을\n정말로 그만하시겠어요?"
        let attributeText = NSMutableAttributedString(string: titleText,
                                                      attributes: [.font: pretendardFont, .foregroundColor: UIColor.black_100])
        return attributeText
    }
    
    private let disposeBag = DisposeBag()
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var remainedDelayCountLabel: UILabel!
    
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var passPenaltyButton: UIButton!
}