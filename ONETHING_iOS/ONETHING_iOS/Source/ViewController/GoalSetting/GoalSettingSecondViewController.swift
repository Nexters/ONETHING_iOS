//
//  GoalSettingSecondViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/17.
//

import RxCocoa
import RxSwift
import UIKit

final class GoalSettingSecondViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.directSetButtonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }

    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var directSetButtonBottomConstraint: NSLayoutConstraint!
    
}
