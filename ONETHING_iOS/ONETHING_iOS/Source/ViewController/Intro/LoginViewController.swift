//
//  LoginViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/11.
//

import UIKit

import RxCocoa
import RxSwift
import ActiveLabel

final class LoginViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabel()
        self.setupTermsLabel()
        self.setupLoadingIndicator()
        self.observeViewModel()
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
        #warning("약관 동의 및 개인정보 이용 약관 WebView 연결해야함")
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
    
    private func setupLoadingIndicator() {
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        self.loadingView.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in make.centerX.centerY.equalToSuperview() }

        self.loadingIndicatorView.stopAnimating()
        self.loadingView.isHidden = true
    }
    
    private func bindButtons() {
        self.appleLoginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.login(type: .apple)
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.completeSubject.observeOnMain(onNext: { [weak self] doneHabbitSetting in
            if doneHabbitSetting == true {
                self?.mainTabbarController?.broadCastRequiredReload()
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.pushGoalSettingController()
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.loadingSubject.observeOnMain(onNext: { [weak self] loading in
            loading ? self?.startLoadingIndicator() : self?.stopLoadingIndicator()
        }).disposed(by: self.disposeBag)
    }
    
    private func startLoadingIndicator() {
        self.loadingView.isHidden = false
        self.loadingIndicatorView.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        self.loadingView.isHidden = true
        self.loadingIndicatorView.stopAnimating()
    }
    
    private func pushGoalSettingController() {
        let viewController = GoalSettingFirstViewController.instantiateViewController(from: .goalSetting)
        
        guard let goalSettingController = viewController else { return }
        self.navigationController?.pushViewController(goalSettingController, animated: true)
    }
    
    private var mainTabbarController: MainTabBarController? {
        return self.navigationController?.presentingViewController as? MainTabBarController
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    private let loadingIndicatorView = UIActivityIndicatorView(style: .medium)
    private let loadingView: UIView = UIView(frame: .zero)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var termsLabel: ActiveLabel!
    @IBOutlet private weak var appleLoginButton: UIButton!
    
}
