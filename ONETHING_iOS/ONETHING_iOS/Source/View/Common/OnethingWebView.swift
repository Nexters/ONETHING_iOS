//
//  OnethingWebView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/24.
//

import UIKit
import WebKit

protocol OnthingWebViewNavigationDelegate: AnyObject {
    func onethingWebView(_ polarisWebView: OnethingWebView, didCommit navigation: WKNavigation!)
    func onethingWebView(_ polarisWebView: OnethingWebView, didFinish navigation: WKNavigation!)
    func onethingWebView(_ polarisWebView: OnethingWebView, didFail navigation: WKNavigation!, withError error: Error)
}


class OnethingWebView: WKWebView {
    
    weak var onthingNavigationDelegate: OnthingWebViewNavigationDelegate?

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.setupWebView()
        self.setupLoadingObservation()
        self.setupLoadingIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupWebView()
        self.setupLoadingObservation()
        self.setupLoadingIndicator()
    }
    
    deinit {
        self.loadingObservation = nil
    }
    
    private func setupWebView() {
        self.uiDelegate = self
        self.navigationDelegate = self
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupLoadingIndicator() {
        self.stopIndicator()
        self.addSubview(self.loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func startIndicator() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    private func stopIndicator() {
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }
    
    private func setupLoadingObservation() {
        let loadingObservation: NSKeyValueObservation = self.observe(\OnethingWebView.isLoading, options: [.initial, .new]) { [weak self] webView, isLoading in
            guard let self = self else { return }

            guard let isLoading = isLoading.newValue else { return }
            isLoading ? self.startIndicator() : self.stopIndicator()
        }
        self.loadingObservation = loadingObservation
    }
    
    private var loadingObservation: NSKeyValueObservation?
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

}

extension OnethingWebView: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction   = UIAlertAction(title: "OK", style: .default) { _ in completionHandler() }

        alertController.addAction(confirmAction)

        guard let visibleController = UIViewController.getVisibleController() else { return }
        visibleController.present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction   = UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) }
        let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        guard let visibleController = UIViewController.getVisibleController() else { return }
        visibleController.present(alertController, animated: true, completion: nil)
    }
    
}

extension OnethingWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.onthingNavigationDelegate?.onethingWebView(self, didCommit: navigation)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.onthingNavigationDelegate?.onethingWebView(self, didFinish: navigation)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopIndicator()
        self.onthingNavigationDelegate?.onethingWebView(self, didFail: navigation, withError: error)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }

        if self.canProcessURL(url) == true { decisionHandler(.allow) }
        else                               { decisionHandler(.cancel) }
    }

    private func canProcessURL(_ url: URL) -> Bool {
        guard url.scheme == "https" || url.scheme == "http" else { return false }
        return true
    }
    
}
