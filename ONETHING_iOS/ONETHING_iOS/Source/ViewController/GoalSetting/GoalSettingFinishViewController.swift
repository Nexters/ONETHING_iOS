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
        self.setupLabels()
        self.setupProgressView()
        self.bindButtons()
    }
    
    private func setupLabels() {
        guard let pretendard_medium = UIFont.createFont(type: .pretendard(weight: .medium), size: 26) else { return }
        guard let pretendard_bold = UIFont.createFont(type: .pretendard(weight: .bold), size: 26) else { return }
        
        guard let subRange = "66일 동안".range(of: "66일") else { return }
        
        let mainAttribute: [NSAttributedString.Key: Any] = [.font: pretendard_medium,
                                                            .foregroundColor: UIColor.black_100]
        let subAttributes: [NSAttributedString.Key: Any] = [.font: pretendard_bold,
                                                            .foregroundColor: UIColor.black_100]
        
        let attributeText = NSMutableAttributedString(string: "66일 동안", attributes: mainAttribute)
        attributeText.addAttributes(subAttributes, range: subRange)
        self.titleSecondLineLabel.attributedText = attributeText
    }
    
    private func setupProgressView() {
        guard let progressView = self.progressView else { return }
        progressView.totalProgress = 3
        progressView.currentProgress = 3
        progressView.currentProgressColor = .black_100
        progressView.totalProgressColor = .black_20
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            let screenRatio = DeviceInfo.screenWidth / 375
            make.width.equalTo(143 * screenRatio)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalTo(self.titleStackView.snp.bottom)
            make.height.equalTo(14)
        }
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.todayStartButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.임시로_dismiss()
            #warning("오늘부터 시작 뷰")
        }).disposed(by: self.disposeBag)
    }
    
    private func 임시로_dismiss() {
        self.dismiss(animated: true)
    }

    private let disposeBag = DisposeBag()
    
    private let progressView: GoalProgressView? = UIView.createFromNib()
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleSecondLineLabel: UILabel!
    
    @IBOutlet private weak var todayStartLabel: UILabel!
    @IBOutlet private weak var todayStartButton: UIButton!
    
}
