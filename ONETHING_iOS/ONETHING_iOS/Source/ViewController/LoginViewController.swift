//
//  LoginViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import AuthenticationServices
import RxCocoa
import RxSwift
import UIKit


final class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabel()
        self.setupTermsLabel()
        self.setupAppleLoginButton()
    }
    
    private func setupTitleLabel() {
        let mainTitle = "66일 습관메이트\n뇽뇽에 어서오세요!"
        guard let mainFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        guard let subFont = UIFont.createFont(type: .pretendard(weight: .regular), size: 26) else { return }
        guard let subRange = mainTitle.range(of: "에 어서오세요!") else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let mainAttributes: [NSAttributedString.Key: Any] = [.font: mainFont, .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: subFont, .foregroundColor: UIColor.white]
        
        let attributeText = NSMutableAttributedString(string: mainTitle, attributes: mainAttributes)
        attributeText.addAttributes(subAttributes, range: subRange)
        
        self.titleLabel.attributedText = attributeText
    }
    
    private func setupTermsLabel() {
        let termsTitle = "계정 생성 시 뇽뇽의 개인정보 수집 방침\n및 이용약관에 동의하게 됩니다."
        
        guard let mainFont = UIFont.createFont(type: .pretendard(weight: .regular), size: 12) else { return }
        guard let personalSubRange = termsTitle.range(of: "개인정보 수집 방침") else { return }
        guard let termsSubRange = termsTitle.range(of: "이용약관") else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        
        let mainAttributes: [NSAttributedString.Key: Any] = [.font: mainFont, .foregroundColor: UIColor.black_40, .paragraphStyle: paragraphStyle]
        let attributeText = NSMutableAttributedString(string: termsTitle, attributes: mainAttributes)
        attributeText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: personalSubRange)
        attributeText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsSubRange)
        self.termsLabel.attributedText = attributeText
    }
    
    private func setupAppleLoginButton() {
        let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleLoginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            SocialManager.sharedInstance.login(with: .apple)
        }).disposed(by: self.disposeBag)
        
        
        let screenRatio = DeviceInfo.screenWidth / 375
        self.view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(termsLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(295 * screenRatio)
            make.height.equalTo(295 * screenRatio * 0.2)
        }
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var termsLabel: UILabel!
    
}
