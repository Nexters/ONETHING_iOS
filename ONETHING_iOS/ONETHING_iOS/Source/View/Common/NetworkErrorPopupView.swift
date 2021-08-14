//
//  NetworkErrorPopupView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/30.
//

import RxCocoa
import RxSwift
import UIKit

class NetworkErrorPopupView: UIView {
    
    typealias Completion = () -> Void
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tag = ViewTag.networkErrorPopup
    }

    // MARK: - internal methods
    static func showInKeyWindow(completion: Completion?) {
        guard let networkPopupView = NetworkErrorPopupView.shared else { return }
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        networkPopupView.show(in: keyWindow) { completion?() }
    }
    
    static func append(completion: Completion?) {
        guard let networkPopupView = NetworkErrorPopupView.shared else { return }
        guard let completion = completion else { return }
        
        networkPopupView.retryActions.append(completion)
    }
    
    static var isPresented: Bool {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        return keyWindow?.viewWithTag(ViewTag.networkErrorPopup) != nil
    }
    
    private static var _shared: NetworkErrorPopupView?
    
    private static var shared: NetworkErrorPopupView? {
        if self._shared != nil { return self._shared! }
        
        guard let networkPopupView: NetworkErrorPopupView = UIView.createFromNib() else { return nil }
        self._shared = networkPopupView
        return self._shared!
    }
    
    private func show(in view: UIView, completion: Completion?) {
        if completion != nil {
            self.retryActions.append(completion!)
        }
        
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.animateForShow()
    }
    
    private func hide() {
        self.animateForHide { [weak self] in
            self?.retryActions.forEach { retryAction in retryAction() }
            self?.retryActions.removeAll()
            Self._shared = nil
            
            self?.removeFromSuperview()
        }
    }
    
    @IBAction func retry(_ sender: Any) {
        self.hide()
    }
    
    private func animateForShow() {
        self.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    private func animateForHide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }

    private var retryActions = [Completion]()
    private let disposeBag = DisposeBag()
    
}
