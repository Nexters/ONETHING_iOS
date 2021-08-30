//
//  GoalSettingFinishViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/07/19.
//

import RxCocoa
import RxSwift
import UIKit
import Lottie

final class GoalSettingFinishViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabels()
        self.setupLottieView()
        self.setupLoadingIndicatorView()
        self.bindButtons()
        self.observeViewModel()
    }
    
    func setHabitInformation(_ title: String, _ postponeTodo: String, _ pushTime: Date, _ postponeCount: Int) {
        self.viewModel.updateHabitInformation(title, postponeTodo, pushTime, postponeCount)
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
    
    private func setupLottieView() {
        self.lottieView.animation = Animation.named("goalFinish")
        self.lottieView.contentMode = .scaleAspectFit
        self.lottieView.loopMode = .playOnce
        self.lottieView.play()
    }
    
    private func setupLoadingIndicatorView() {
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.loadingIndicatorView.isHidden = true
        self.loadingIndicatorView.stopAnimating()
    }
    
    private func bindButtons() {
        self.backButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.todayStartButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.requestCreateHabit()
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.loadingSubject.observeOnMain(onNext: { [weak self] loading in
            self?.todayStartButton.isUserInteractionEnabled = loading == false
            loading ? self?.startLoadingIndicator() : self?.stopLoadingIndicator()
        }).disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject.observeOnMain(onNext: { [weak self] in
            guard let self = self                                         else { return }
            guard let popupView: CustomPopupView = UIView.createFromNib() else { return }
            popupView.configure(title: "알림은\n2차 출시에 사용할 수 있어요!", image: #imageLiteral(resourceName: "prepare_rabbit"))
            popupView.setEnableTapGesture(false)
            popupView.show(in: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                popupView.hide { [weak self] in
                    self?.mainTabbarController?.broadCastRequiredReload()
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func startLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicatorView.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
        self.loadingIndicatorView.stopAnimating()
    }
    
    private var mainTabbarController: MainTabBarController? {
        return self.navigationController?.presentingViewController as? MainTabBarController
    }

    private let disposeBag = DisposeBag()
    private let viewModel = GoalSettingFinishViewModel()
    
    private let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleSecondLineLabel: UILabel!
    
    @IBOutlet private weak var todayStartLabel: UILabel!
    @IBOutlet private weak var todayStartButton: UIButton!
    @IBOutlet private weak var lottieView: AnimationView!
    
}
