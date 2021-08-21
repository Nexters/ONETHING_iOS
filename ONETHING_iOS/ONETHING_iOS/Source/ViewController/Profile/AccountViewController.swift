//
//  AccountViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import RxCocoa
import RxSwift
import UIKit

final class AccountViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingIndicatorView()
        self.bindButtons()
        self.observeViewModel()
        
        self.viewModel.requestUserInform()
    }
    
    private func setupLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.stopLoadingIndicator()
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.logoutButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.requestLogout()
        }).disposed(by: self.disposeBag)
        
        self.withDrawlButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let titleText = "회원탈퇴시\n모든 습관 기록이\n영구적으로 삭제돼요.\n\n그래도 탈퇴하시겠어요?"
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })          else { return }
            guard let confirmPopupView: ConfirmPopupView = UIView.createFromNib()                        else { return }
            guard let highlightedRange = titleText.range(of: "모든 습관 기록이\n영구적으로 삭제돼요.")             else { return }
            guard let pretendardFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 16) else { return }
            
            let attributeText = NSMutableAttributedString(string: titleText,
                                                          attributes: [.font: pretendardFont,
                                                                       .foregroundColor: UIColor.black_100])
            attributeText.addAttribute(.foregroundColor, value: UIColor.red_default, range: highlightedRange)
            confirmPopupView.configure(attributeText, confirmHandler: {
                                        self.viewModel.requestWithdrawl()
            })
            confirmPopupView.show(in: keyWindow)
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.userRelay.observeOnMain(onNext: { [weak self] user in
            guard let self = self else { return }
            guard let user = user else { return }
            
            self.emailLabel.text = user.email
        }).disposed(by: self.disposeBag)
        
        self.viewModel.loadingSubject.observeOnMain(onNext: { [weak self] loading in
            loading ? self?.startLoadingIndicator() : self?.stopLoadingIndicator()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.logoutSuccessSubject.observeOnMain(onNext: { [weak self] in
            self?.mainTabbarController?.processLogout()
        }).disposed(by: self.disposeBag)
    }
    
    private func startLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicatorView.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
        self.loadingIndicatorView.stopAnimating()
    }
    
    private var mainTabbarController: MainTabBarController? {
        return self.navigationController?.tabBarController as? MainTabBarController
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = AccountViewModel()
    
    private let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var withDrawlButton: UIButton!
    
}
