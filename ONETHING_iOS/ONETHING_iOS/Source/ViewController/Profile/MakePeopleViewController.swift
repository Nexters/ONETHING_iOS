//
//  MakePeopleViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/21.
//

import RxCocoa
import RxSwift
import UIKit

class MakePeopleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindButtons()
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    
}
