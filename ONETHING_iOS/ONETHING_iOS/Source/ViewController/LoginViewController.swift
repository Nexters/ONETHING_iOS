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


final class LoginViewController: BaseViewController, Reusable {
    
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
            #warning("SocialManager.sharedInstance.login(with: .apple) 이거 실질적으로 작동하도록 구현해야함")
            self.dismissLoginViewController()
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
    
    private func dismissLoginViewController() {
        #warning("""
            1. 습관을 한번도 설정하지 않은 회원이면 바로 네비게이션 뷰로 환경 설정 페이지로 갑니다.
            2. 습관이 있거나 습관을 완료한 이력이 있는 회원이라면 dismiss 하여 HomeViewController로 가게 됩니다.
            """)
        if self.습관을_한번도_설정하지_않은_회원이라면 {
            guard let goalSettingFirstViewController = UIStoryboard(
                name: StoryboardName.goalSetting,
                bundle: nil
            ).instantiateViewController(withIdentifier: GoalSettingFirstViewController.reuseIdentifier) as? GoalSettingFirstViewController else { return }
            
            self.navigationController?.pushViewController(goalSettingFirstViewController, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    private var 습관을_한번도_설정하지_않은_회원이라면: Bool {
        return true
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var termsLabel: UILabel!
    
}
