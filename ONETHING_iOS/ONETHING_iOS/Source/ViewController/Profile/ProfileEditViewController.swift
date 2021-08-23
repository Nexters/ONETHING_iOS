//
//  ProfileEditViewController.swift
//  ONETHING_iOS
//
//  Created by Dongmin on 2021/08/23.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfileEditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardDismissTapGesture()
        self.bindButtons()
        self.bindTextField()
        self.observeViewModel()
    }
    
    private func bindButtons() {
        self.closeButton.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.saveButton.rx.tap.subscribe(onNext: {
            self.viewModel.requestSetProfile()
        }).disposed(by: self.disposeBag)
        
        self.studyProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.study)
        }).disposed(by: self.disposeBag)
        
        self.healthProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.strong)
        }).disposed(by: self.disposeBag)
        
        self.heartProfileButton?.rx.tap.observeOnMain(onNext: { [weak self] in
            self?.viewModel.updateSelectedProfile(.heart)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindTextField() {
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
    
    func updateSetButton(as enable: Bool) {
        self.saveButton.isUserInteractionEnabled = enable
    }
    
    private static let maxCount: Int = 10
    
    private var studyProfileButton: UIButton?  { return self.profileButtons.first }
    private var healthProfileButton: UIButton? { return self.profileButtons[safe: 1] }
    private var heartProfileButton: UIButton?  { return self.profileButtons.last }
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileEditViewModel()

    @IBOutlet private weak var selectedProfileImageView: UIImageView!
    @IBOutlet private var profileButtons: [UIButton]!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nicknameCountLabel: UILabel!
    
}
