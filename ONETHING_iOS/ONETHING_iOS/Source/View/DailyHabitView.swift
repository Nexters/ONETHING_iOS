//
//  DailyHabitView.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/20.
//

import UIKit

import Then

protocol DailyHabitViewCloseButtonDelegate: UIViewController {
    func dailyHabitViewDidTapCloseButton(_ dailyHabitView: DailyHabitView)
}

protocol DailyHabitViewPhotoViewDelegate: UIViewController {
    func dailyHabitViewDidTapPhotoButton(_ dailyHabitView: DailyHabitView, actionSheet: UIAlertController)
    func dailyHabitViewDidPickerFinish(_ dailyHabitView: DailyHabitView)
    func dailyHabitViewWillPickerPresent(_ dailyHabitView: DailyHabitView, picker: UIImagePickerController)
}

final class DailyHabitView: UIView {
    private let closeButton = UIButton()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let photoView = UIImageView()
    private let enrollPhotoButton = UIButton()
    private let habitTextView = HabitTextView()
    
    weak var dailyHabitViewCloseButtonDelegate: DailyHabitViewCloseButtonDelegate?
    weak var dailyHabitViewPhotoViewDelegate: DailyHabitViewPhotoViewDelegate?
    private let picker = UIImagePickerController()
    
    init(frame: CGRect = .zero, hideCloseButton: Bool) {
        super.init(frame: frame)
        
        self.setupAddSubviews()
        self.setupCloseButton(with: hideCloseButton)
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupPhotoView()
        self.setupEnrollPhotoButton()
        self.setupHabitTextView()
        picker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupAddSubviews() {
        [closeButton, dateLabel, timeLabel, photoView, habitTextView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupCloseButton(with hideCloseButton: Bool) {
        self.closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.closeButton.tintColor = .darkGray
        self.closeButton.isHidden = hideCloseButton == true ? true : false
        self.closeButton.addTarget(self, action: #selector(self.closeButtonDidTouch), for: .touchUpInside)
        
        let constant: CGFloat = self.closeButton.isHidden == false ? 20 : 0
        self.closeButton.snp.makeConstraints {
            $0.width.height.equalTo(constant)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(self.timeLabel)
        }
    }
    
    @objc private func closeButtonDidTouch() {
        self.dailyHabitViewCloseButtonDelegate?.dailyHabitViewDidTapCloseButton(self)
    }
    
    private func setupTimeLabel() {
        self.timeLabel.text = "5:05 PM"
        self.timeLabel.textColor = .black_40
        self.timeLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
        
        self.timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.closeButton.snp.leading).offset(-10)
            $0.bottom.equalTo(self.snp.top)
        }
    }
    
    private func setupDateLabel() {
        self.dateLabel.text = "2021.07.21"
        self.dateLabel.textColor = .black_60
        self.dateLabel.font = UIFont.createFont(type: .montserrat(weight: .medium), size: 10)
        
        self.dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.timeLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(self.timeLabel)
        }
    }
    
    private func setupPhotoView() {
        self.photoView.image = UIImage(named: "photo_default")
        self.photoView.contentMode = .scaleAspectFill
        self.photoView.isUserInteractionEnabled = true
        self.photoView.layer.cornerRadius = 16
        self.photoView.clipsToBounds = true
        
        self.photoView.snp.makeConstraints {
            $0.top.equalTo(self.timeLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
        }
    }
    
    private func setupEnrollPhotoButton() {
        self.enrollPhotoButton.setImage(UIImage(named: "enroll_photo"), for: .normal)
        self.enrollPhotoButton.addTarget(self, action: #selector(enrollPhotoButtonDidTouch), for: .touchUpInside)
        self.enrollPhotoButton.contentMode = .scaleAspectFit
        self.photoView.addSubview(self.enrollPhotoButton)
        
        self.enrollPhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18)
            $0.height.equalToSuperview().multipliedBy(0.1625)
            $0.width.equalTo(self.enrollPhotoButton.snp.height).multipliedBy(4)
        }
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
        self.picker.sourceType = .photoLibrary
        self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewWillPickerPresent(self, picker: self.picker)
    }
    
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            self.picker.sourceType = .camera
            self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewWillPickerPresent(self, picker: self.picker)
        } else {
            print("Camera not available")
        }
    }
    
    private func setupHabitTextView() {
        self.habitTextView.placeholderLabel.isHidden = true
        self.habitTextView.snp.makeConstraints {
            $0.top.equalTo(self.photoView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
            $0.bottom.equalToSuperview()
        }
    }
    
    func update(contentText: String?) {
        
    }
    
    func update(photoImage: UIImage) {
        
    }
}

extension DailyHabitView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.photoView.image = image
        self.dailyHabitViewPhotoViewDelegate?.dailyHabitViewDidPickerFinish(self)
    }
}
