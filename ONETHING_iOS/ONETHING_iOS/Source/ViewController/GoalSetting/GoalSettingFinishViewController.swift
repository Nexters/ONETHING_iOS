//
//  GoalSettingFinishViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import RxCocoa
import RxSwift
import UIKit

final class GoalSettingFinishViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupProgressView()
        self.bindButtons()
    }
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 3
        progressView.currentProgressColor = .black_100
        progressView.totalProgressColor = .black_20
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleStackView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(self.titleStackView.snp.bottom)
            make.height.equalTo(14)
        }
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.reserveButton.rx.tap.observeOnMain(onNext: { [weak self] in
            #warning("시작날짜 예약하는 뷰")
        }).disposed(by: self.disposeBag)
        
        self.todayStartButton.rx.tap.observeOnMain(onNext: { [weak self] in
            #warning("오늘부터 시작 뷰")
        }).disposed(by: self.disposeBag)
    }

    private let disposeBag = DisposeBag()
    
    private let progressView: GoalProgressView? = UIView.createFromNib()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleStackView: UIStackView!
    
    @IBOutlet private weak var reserveLabel: UILabel!
    @IBOutlet private weak var reserveButton: UIButton!
    @IBOutlet private weak var todayStartLabel: UILabel!
    @IBOutlet private weak var todayStartButton: UIButton!
    
}
