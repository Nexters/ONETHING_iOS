//
//  HabitModfiyViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/25.
//

import UIKit

import RxSwift
import RxCocoa

final class HabitModfiyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindingButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func bindingButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.completeButton.rx.tap.observeOnMain(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
}
