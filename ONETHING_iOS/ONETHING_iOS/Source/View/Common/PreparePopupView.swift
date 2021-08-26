//
//  NotReadyPopupView.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/01.
//

import RxCocoa
import RxSwift
import UIKit

final class PreparePopupView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = "서비스를\n준비중이에요!"
        self.bindTapGesture()
    }
    
    func show(in targetController: UIViewController) {
        targetController.view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.showCrossDissolve()
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.observeOnMain(onNext: { [weak self] _ in
            self?.hideCrossDissolve(completion: {
                self?.removeFromSuperview()
            })
        }).disposed(by: self.disposeBag)
        self.dimView.addGestureRecognizer(tapGesture)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var dimView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
}
