//
//  DailyHabitView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

import Then
import Kingfisher
import Photos

protocol DailyHabitViewCloseButtonDelegate: UIViewController {
    func dailyHabitViewDidTapCloseButton(_ dailyHabitView: DailyHabitView)
}

protocol DailyHabitViewPhotoViewDelegate: UIViewController {
    func dailyHabitViewDidTapPhotoButton(_ dailyHabitView: DailyHabitView, actionSheet: UIAlertController)
    func dailyHabitViewDidPickerFinish(_ dailyHabitView: DailyHabitView)
    func dailyHabitViewWillPickerPresent(_ dailyHabitView: DailyHabitView, picker: UIImagePickerController)
}

final class DailyHabitView: UIView {
    static let photoDefault = UIImage(named: "photo_default")
    let enrollPhotoButton = UIButton()
    let closeButton = LargeTouchableButton()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let photoView = UIImageView()
    private let habitTextView = HabitTextView()
    
    weak var dailyHabitViewCloseButtonDelegate: DailyHabitViewCloseButtonDelegate?
    weak var dailyHabitViewPhotoViewDelegate: DailyHabitViewPhotoViewDelegate?
    private let picker = UIImagePickerController()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.addSubviews()
        self.setupCloseButton()
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupPhotoView()
        self.setupEnrollPhotoButton()
        self.picker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        self.layoutCloseButton()
        self.layoutTimeLabel()
        self.layoutDateLabel()
        self.layoutPhotoView()
        self.layoutEnrollPhotoButton()
        self.layoutHabitTextView()
    }
    
    func setEditingEnable(_ enable: Bool) {
        self.habitTextView.isEditable = enable
    }
    
    // MARK: - setup Layouts
    
    private func layoutCloseButton() {
        self.superview?.addSubview(self.closeButton)
        let constant: CGFloat = self.closeButton.isHidden == false ? 20 : 0
        self.closeButton.snp.makeConstraints {
            $0.width.height.equalTo(constant)
            $0.trailing.equalTo(self)
            $0.centerY.equalTo(self.timeLabel)
        }
    }
    
    private func layoutTimeLabel() {
        self.timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.closeButton.snp.leading).offset(-10)
            $0.bottom.equalTo(self.snp.top)
        }
    }
    
    private func layoutDateLabel() {
        self.dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.timeLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(self.timeLabel)
        }
    }
    
    private func layoutPhotoView() {
        self.photoView.snp.makeConstraints {
            $0.top.equalTo(self.timeLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
    }
    
    private func layoutEnrollPhotoButton() {
        self.enrollPhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18)
            $0.height.equalToSuperview().multipliedBy(0.1625)
            $0.width.equalTo(self.enrollPhotoButton.snp.height).multipliedBy(4)
        }
    }
    
    private func layoutHabitTextView() {
        self.habitTextView.snp.makeConstraints {
            $0.top.equalTo(self.photoView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - setup Attributes
    
    private func addSubviews() {
        [self.dateLabel, self.timeLabel, self.photoView, self.habitTextView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupCloseButton() {
        self.closeButton.setImage(UIImage(named: "close_button"), for: .normal)
        self.closeButton.setImage(UIImage(named: "close_button"), for: .highlighted)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonDidTouch), for: .touchUpInside)
        self.closeButton.contentMode = .scaleAspectFit
    }
    
    @objc private func closeButtonDidTouch() {
        self.dailyHabitViewCloseButtonDelegate?.dailyHabitViewDidTapCloseButton(self)
    }
    
    private func setupTimeLabel() {
        self.timeLabel.textColor = .black_40
        self.timeLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
    }
    
    private func setupDateLabel() {
        self.dateLabel.textColor = .black_60
        self.dateLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
    }
    
    private func setupPhotoView() {
        self.photoView.image = Self.photoDefault
        self.photoView.contentMode = .scaleAspectFill
        self.photoView.isUserInteractionEnabled = true
        self.photoView.layer.cornerRadius = 16
        self.photoView.clipsToBounds = true
    }
    
    private func setupEnrollPhotoButton() {
        self.enrollPhotoButton.setImage(UIImage(named: "enroll_photo"), for: .normal)
        self.enrollPhotoButton.addTarget(self, action: #selector(enrollPhotoButtonDidTouch), for: .touchUpInside)
        self.enrollPhotoButton.contentMode = .scaleAspectFit
        self.photoView.addSubview(self.enrollPhotoButton)
    }
    
    @objc private func enrollPhotoButtonDidTouch() {
        let actionSheet =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then {
            let libraryAction =  UIAlertAction(title: "앨범", style: .default) { [weak self] _ in self?.openLibrary() }
            let cameraAction =  UIAlertAction(title: "카메라", style: .default) { [weak self] _ in self?.openCamera() }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            $0.addAction(libraryAction)
            $0.addAction(cameraAction)
            $0.addAction(cancel)
        }
        
        self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewDidTapPhotoButton(self, actionSheet: actionSheet)
    }
    
    private func openLibrary() {
        MediaAuthorizationManager.sharedInstance.requestGalleryAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if granted {
                    self.picker.sourceType = .photoLibrary
                    self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewWillPickerPresent(self, picker: self.picker)
                } else {
                    self.showAuthorizationView(.gallery)
                }
            }
        }
    }
    
    private func openCamera() {
        MediaAuthorizationManager.sharedInstance.requestCameraAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if granted {
                    self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewWillPickerPresent(self, picker: self.picker)
                    self.picker.sourceType = .camera
                } else {
                    self.showAuthorizationView(.camera)
                }
            }
        }
    }
    
    private func showAuthorizationView(_ type: MediaType) {
        guard let authorizationView: AuthorizationView = UIView.createFromNib()             else { return }
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        authorizationView.configure(type) {
            guard let optionURL = URL(string: "\(UIApplication.openSettingsURLString)") else { return }
            UIApplication.shared.open(optionURL, options: [:])
        }
        authorizationView.show(in: keyWindow)
    }
    
    var contentText: String? {
        return self.habitTextView.text
    }
    
    var photoImage: UIImage? {
        return self.photoView.image
    }
    
    func update(with viewModel: DailyHabitViewModelable) {
        self.habitTextView.text = viewModel.contentText
        self.dateLabel.text = viewModel.dateText
        self.timeLabel.text = viewModel.timeText
    }
    
    func update(photoImage: UIImage) {
        self.photoView.alpha = 0
        self.photoView.image = photoImage
        self.photoView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        UIView.animate(withDuration: 0.5) {
            self.photoView.alpha = 1
            self.photoView.transform = .identity
        }
    }
    
    func hidePlaceHolderLabelOfTextView() {
        self.habitTextView.placeholderLabel.isHidden = true
    }
    
    func hideTextCountLabelOfTextView() {
        self.habitTextView.textCountLabel.isHidden = true
    }
}

extension DailyHabitView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.photoView.image = image
        self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewDidPickerFinish(self)
    }
}
