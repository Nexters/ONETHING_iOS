//
//  AccountViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import RxCocoa
import RxSwift
import UIKit

final class AccountViewController: UIViewController {

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
            self?.viewModel.requestWithdrawl()
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
