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
    private var penaltyTextableViews: [PenaltyTextableView]?
    private let scrollView = UIScrollView()
    private let innerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    weak var delegate:  WritingPenaltyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardDismissTapGesture()
        self.setupPenaltyInfoView()
        self.setupScrollView()
        self.setupInnerStackView()
        self.bindButtons()
        
        let penaltyTextableViews = (0..<7).compactMap { _ -> PenaltyTextableView? in
            let view: PenaltyTextableView? = UIView.createFromNib()
            return view
        }
        
        penaltyTextableViews.forEach {
            self.innerStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
                $0.width.equalToSuperview()
            }
        }
        
        self.penaltyTextableViews = penaltyTextableViews
    }
    
    private func setupPenaltyInfoView() {
        guard let penaltyInfoView = self.penaltyInfoView else { return }

        penaltyInfoView.do {
            $0.isUserInteractionEnabled = false
            $0.arrowImageView.isHidden = true

        }
        
        self.penaltyInfoContainerView.addSubview(penaltyInfoView)
        penaltyInfoView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        penaltyInfoView.countBoxView.snp.remakeConstraints {
            $0.width.equalTo(64)
        }
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            guard let penaltyInfoView = self.penaltyInfoView else { return }
            
            $0.top.equalTo(penaltyInfoView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(self.completeButton.snp.top).offset(-43)
        }
    }
    
    private func setupInnerStackView() {
        self.scrollView.addSubview(self.innerStackView)
        
        self.innerStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.height.equalTo(self.innerStackView)
        }
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
    
    @IBOutlet private weak var penaltyInfoContainerView: UIView!
    private let penaltyInfoView: PenaltyInfoView? = UIView.createFromNib()
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var completeLabel: UILabel!
}
