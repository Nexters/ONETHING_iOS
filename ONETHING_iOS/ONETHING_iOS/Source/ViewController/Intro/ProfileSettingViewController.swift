//
//  ProfileSettingViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/22.
//

import RxCocoa
import RxSwift
import UIKit

class ProfileSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardDismissTapGesture()
        self.updateSetButton(as: false)
        self.setupTextField()
        self.setupTitleLabel()
        self.bindButtons()
        self.observeViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buttonBottomConstraint.constant = 12 + DeviceInfo.safeAreaBottomInset
    }
    
    private func setupTitleLabel() {
        guard let normalFont = UIFont.createFont(type: .pretendard(weight: .light), size: 26) else { return }
        guard let boldFont = UIFont.createFont(type: .pretendard(weight: .bold), size: 26)    else { return }
        let title = "습관을 함께할\n캐릭터 프로필을 설정해주세요"
        
        guard let boldRange = title.range(of: "캐릭터 프로필") else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [.font: normalFont, .foregroundColor: UIColor.black_100]
        let attributeText = NSMutableAttributedString(string: title, attributes: attributes)
        attributeText.addAttribute(.font, value: boldFont, range: boldRange)
        self.titleLabel.attributedText = attributeText
    }
    
    private func setupTextField() {
        guard let placeHolderFont = UIFont.createFont(type: .pretendard(weight: .semiBold), size: 20) else { return }
        
        self.nicknameTextField.attributedPlaceholder = NSMutableAttributedString(string: "닉네임을 적어주세요.",
                                                                                 attributes: [.foregroundColor: UIColor.black_20,
                                                                                              .font: placeHolderFont])
        
        self.nicknameTextField.rx.controlEvent(.editingChanged).observeOnMain(onNext: { [weak self] in
            guard let self = self else { return }
            guard let text = self.nicknameTextField.text else { return }
            
            guard text.count <= type(of: self).maxCount else {
                self.nicknameTextField.text?.removeLast()
                return
            }
            
            self.nicknameCountLabel.text = String(format: "%d / 10", text.count)
            self.updateSetButton(as: text.count != 0)
            self.viewModel.updateNickname(text)
        }).disposed(by: self.disposeBag)
    }
    
    private func updateSetButton(as enable: Bool) {
        self.setButton.isUserInteractionEnabled = enable
        self.setLabel.textColor = enable ? .white : .black_80
        self.setButton.backgroundColor = enable ? .black_100 : .black_40
    }
    
    private func bindButtons() {
        self.studyProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.study)
        }).disposed(by: self.disposeBag)
        
        self.healthProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.strong)
        }).disposed(by: self.disposeBag)
        
        self.heartProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.heart)
        }).disposed(by: self.disposeBag)
        
        self.setButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.requestSetProfile()
        }).disposed(by: self.disposeBag)
    }
    
    private func observeViewModel() {
        self.viewModel.selectedProfileRelay.observeOnMain(onNext: { [weak self] selectedProfile in
            guard let self = self else { return }
            guard let selectedButton = self.profileButton(of: selectedProfile) else { return }
            
            self.selectedProfileImageView.image = selectedProfile.image
            self.profileButtons.forEach { profileButton in
                if profileButton == selectedButton {
                    profileButton.alpha = 1
                    profileButton.borderWidth = 2
                    profileButton.borderColor = UIColor(hexString: "#FF6650")
                } else {
                    profileButton.alpha = 0.5
                    profileButton.borderColor = .clear
                }
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.completeSubject.observeOnMain(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    private func profileButton(of profileType: OnethingProfileType) -> UIButton? {
        switch profileType {
        case .study:  return self.studyProfileButton
        case .strong: return self.healthProfileButton
        case .heart:  return self.heartProfileButton
        }
    }
    
    private static let maxCount: Int = 10
    
    private var studyProfileButton: UIButton?  { return self.profileButtons.first }
    private var healthProfileButton: UIButton? { return self.profileButtons[safe: 1] }
    private var heartProfileButton: UIButton?  { return self.profileButtons.last }
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileSettingViewModel()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectedProfileImageView: UIImageView!
    @IBOutlet var profileButtons: [UIButton]!
    
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nicknameCountLabel: UILabel!
    
    @IBOutlet private weak var setButton: UIButton!
    @IBOutlet private weak var setLabel: UILabel!
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    
}
