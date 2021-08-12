//
//  CommonWebViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/24.
//

import RxSwift
import RxCocoa
import UIKit
import WebKit

class CommonWebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabel()
        self.setupWebView()
        self.bindButtons()
    }
    
    func setWebViewTitle(_ title: String) {
        self.webViewTitle = title
    }
    
    func configureURL(_ url: URL) {
        self.webURL = url
    }
    
    private func setupTitleLabel() {
        self.titleLabel.text = self.webViewTitle
    }
    
    private func setupWebView() {
        guard let webURL = self.webURL else { return }
        
        let webviewLoadRequest = URLRequest(url: webURL)
        self.webView.load(webviewLoadRequest)
        self.webView.onethingNavigationDelegate = self
    }
    
    private func bindButtons() {
        self.closeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private var webURL: URL?
    private var webViewTitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var webView: OnethingWebView!
    
}

extension CommonWebViewController: OnthingWebViewNavigationDelegate {
    
    func onethingWebView(_ polarisWebView: OnethingWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func onethingWebView(_ polarisWebView: OnethingWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func onethingWebView(_ polarisWebView: OnethingWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
