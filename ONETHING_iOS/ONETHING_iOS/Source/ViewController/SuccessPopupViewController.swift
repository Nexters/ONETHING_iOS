//
//  SuccessPopupViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/10/14.
//

import UIKit

import SnapKit
import Then
import Lottie

protocol SuccessPopupViewControllerDelegate: AnyObject {
    func successPopupViewControllerDidTapButton(_ viewController: SuccessPopupViewController)
}

final class SuccessPopupViewController: BaseViewController {
    var viewModel: SuccessPopupViewModel?
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let upperLineView = UIView()
    private let lowerLineView = UIView()
    private let progressTitleLabel = UILabel()
    private let progressContentLabel = UILabel()
    private let percentTitleLabel = UILabel()
    private let percentContentLabel = UILabel()
    private let completeButton = UIButton()
    private let lottieView = AnimationView()
    weak var delegate: SuccessPopupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCloseButton()
        self.setupLottieView()
        self.setupTitleLabel()
        self.setupSubTitleLabel()
        self.setupBoxedView()
        self.setupCompleteButton()
        
        self.updateViews(with: self.viewModel)
    }
    
    private func setupCloseButton() {
        self.closeButton.setImage(UIImage(named: "x_icon"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonDidTap), for: .touchUpInside)
        
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-32)
            $0.top.equalToSuperview().offset(54)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
    
    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.successPopupViewControllerDidTapButton(self)
        })
    }
    
    private func setupLottieView() {
        self.lottieView.do {
            $0.animation = Animation.named("success")
            $0.contentMode = .scaleAspectFill
            $0.loopMode = .loop
            $0.play()
        }
        
        self.view.addSubview(self.lottieView)
        self.lottieView.snp.makeConstraints {
            $0.top.equalTo(self.closeButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(self.lottieView.snp.width).multipliedBy(0.67)
        }
    }
    
    private func setupTitleLabel() {
        self.titleLabel.do {
            $0.font = UIFont(name: "Pretendard-Bold", size: 26)
            $0.textColor = .red_default
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.lottieView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupSubTitleLabel() {
        guard let ultraFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        guard let boldFont = UIFont.createFont(type: .pretendard(weight: .medium), size: 26) else { return }
        
        self.subTitleLabel.do {
            $0.text = "습관 달성! 축하해요!"
            $0.font = boldFont
            $0.textColor = .black_100
            
            let fullText = $0.text ?? ""
            let range = (fullText as NSString).range(of: "습관 달성!")
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(.font, value: ultraFont, range: range)
            $0.attributedText = attributedString
        }
        
        self.view.addSubview(self.subTitleLabel)
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupBoxedView() {
        self.view.addSubview(self.upperLineView)
        self.view.addSubview(self.progressTitleLabel)
        self.view.addSubview(self.progressContentLabel)
        self.view.addSubview(self.percentTitleLabel)
        self.view.addSubview(self.percentContentLabel)
        self.view.addSubview(self.lowerLineView)
        
        self.upperLineView.backgroundColor = .black_20
        self.upperLineView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(1.5)
        }
        
        self.progressTitleLabel.do {
            $0.text = "진행 기간"
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.textColor = .black_60
        }
        
        self.progressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.upperLineView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(32)
        }
        
        self.progressContentLabel.do {
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
        self.progressContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.progressTitleLabel)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        self.percentTitleLabel.do {
            $0.text = "성공률"
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
            $0.textColor = .black_60
        }
        self.percentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.progressTitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(self.progressTitleLabel)
        }
        
        self.percentContentLabel.do {
            $0.textColor = .black_100
            $0.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 16)
        }
        self.percentContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.percentTitleLabel)
            $0.trailing.equalTo(self.progressContentLabel)
        }
        
        self.lowerLineView.backgroundColor = .black_20
        self.lowerLineView.snp.makeConstraints {
            $0.top.equalTo(self.percentTitleLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(1.5)
        }
    }
    
    private func setupCompleteButton() {
        self.completeButton.do {
            $0.setTitle("성공카드 확인하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor($0.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
            $0.titleLabel?.font = UIFont.createFont(type: .pretendard(weight: .regular), size: 18)
            $0.backgroundColor = .black_100
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(self.completeButtonDidTap), for: .touchUpInside)
        }
        
        self.view.addSubview(self.completeButton)
        self.completeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            let safeArea = self.view.safeAreaLayoutGuide
            $0.bottom.equalTo(safeArea).offset(-44)
            $0.width.equalTo(311)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func completeButtonDidTap() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.successPopupViewControllerDidTapButton(self)
        })
    }
    
    private func updateViews(with viewModel: SuccessPopupViewModel?) {
        guard let viewModel = viewModel else { return }
        
        self.titleLabel.text = viewModel.titleText
        self.progressContentLabel.text = viewModel.progressText
        self.percentContentLabel.text = viewModel.percentText
    }
}
