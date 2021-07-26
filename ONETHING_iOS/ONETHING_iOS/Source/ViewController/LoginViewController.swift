//
//  LoginViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import RxCocoa
import RxSwift
import UIKit
import ActiveLabel

final class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabel()
        self.setupTermsLabel()
        self.bindButtons()
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
        guard let lightFont = UIFont.createFont(type: .pretendard(weight: .light), size: 12) else { return }
        guard let boldFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 12)   else { return }
        
        let termsText = "계정 생성 시 뇽뇽의 개인정보 수집 방침\n및 이용약관에 동의하게 됩니다."
        
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: lightFont, .foregroundColor: UIColor.black_40]
        let linkAttribute: [NSAttributedString.Key: Any]   = [.font: boldFont, .foregroundColor: UIColor.black_40,
                                                              .underlineStyle: NSUnderlineStyle.single.rawValue]
    
        let personal = ActiveType.custom(pattern: "개인정보 수집 방침")
        let serviceOfTerms = ActiveType.custom(pattern: "이용약관")
        self.termsLabel.enabledTypes = [personal, serviceOfTerms]
        self.termsLabel.configureLinkAttribute = { type, attributes, enable in
            if type == personal             { return linkAttribute }
            else if type == serviceOfTerms  { return linkAttribute }
            else                            { return normalAttribute }
        }
        self.termsLabel.text = termsText
        
        self.termsLabel.handleCustomTap(for: personal) {
            print($0)
        }
        
        self.termsLabel.handleCustomTap(for: serviceOfTerms) {
            print($0)
        }
    }
    
    private func bindButtons() {
        self.appleLoginButton.rx.tap.subscribe(onNext: {
            SocialManager.sharedInstance.login(with: .apple) { }
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var termsLabel: ActiveLabel!
    @IBOutlet private weak var appleLoginButton: UIButton!
    
}
