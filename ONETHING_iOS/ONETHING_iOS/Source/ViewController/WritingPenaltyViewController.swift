//
//  WritingPenaltyViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/08/24.
//

import UIKit

import RxSwift
import RxCocoa

protocol WritingPenaltyViewControllerDelegate: AnyObject {
    func writingPenaltyViewControllerDidTapBackButton(_ writingPenaltyViewController: WritingPenaltyViewController)
    func writingPenaltyViewControllerDidTapCompleteButton(_ writingPenaltyViewController: WritingPenaltyViewController)
}

final class WritingPenaltyViewController: BaseViewController {
    weak var delegate:  WritingPenaltyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindButtons()
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.writingPenaltyViewControllerDidTapBackButton(self)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.completeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.writingPenaltyViewControllerDidTapCompleteButton(self)
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var backButton: UIButton!
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var completeLabel: UILabel!
}
