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
    private let boxedView = SuccessBoxedView()
    private let completeButton = UIButton()
    private let lottieView = AnimationView()
    private let commentView = UIImageView()
    private let commentLabel = UILabel()
    weak var delegate: SuccessPopupViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCloseButton()
        self.setupLottieView()
        self.setupTitleLabel()
        self.setupSubTitleLabel()
        self.setupBoxedView()
        self.setupCompleteButton()
        self.setupCommentView()
        
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
            $0.top.equalTo(self.closeButton.snp.bottom).offset(3)
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
        self.view.addSubview(self.boxedView)
        
        self.boxedView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupCompleteButton() {
        self.completeButton.do {
            $0.setTitle("닫기", for: .normal)
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
    
    private func setupCommentView() {
        self.commentView.image = UIImage(named: "comment_view")
        self.commentView.contentMode = .scaleAspectFit
        self.view.addSubview(self.commentView)
        self.commentView.snp.makeConstraints {
            $0.centerX.equalTo(self.completeButton)
            $0.width.equalTo(self.completeButton).multipliedBy(0.7)
            $0.height.equalTo(self.commentView.snp.width).multipliedBy(36.0/208.0)
            $0.bottom.equalTo(self.completeButton.snp.top).offset(-9)
        }
        
        self.commentLabel.do {
            $0.text = "내 달성 습관을 볼 수 있도록 준비 중이에요"
            $0.font = UIFont.createFont(
                type: .pretendard(weight: .medium),
                size: 12)
            $0.textColor = .black_60
        }
        self.commentView.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(7.5)
        })
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
        self.boxedView.update(with: self.viewModel)
    }
}
