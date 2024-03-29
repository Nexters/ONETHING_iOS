//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

import Then
import RxSwift
import RxCocoa

protocol HabitWritingViewControllerDelegate: AnyObject {
    func update(currentDailyHabitModel: DailyHabitResponseModel)
}

final class HabitWritingViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    
    private let backBtnTitleView = BackBtnTitleView()
    private let completeButton = CompleteButton()
    private let dailyHabitView = DailyHabitView()
    private let keyboardDismissableView = UIView()
    private let habitStampView = HabitStampView()
    private var lockPopupView: LockView?
    private let backgroundDimView = BackgroundDimView()
    var delegate: HabitWritingViewControllerDelegate?
    
    var viewModel: HabitWritingViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardDismissTapGesture()
        self.setupKeyboardDismissableView()
        self.setupBackBtnTitleView()
        self.setupDailyHabitView()
        self.setupCompleteButton()
        self.setupHabitStampView()
        self.setupBackgounndDimColorView()
        self.updateViewsWithViewModel()
        self.bindingButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.keyboardDismissableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardDismissableView() {
        self.view.addSubview(self.keyboardDismissableView)
        
        self.keyboardDismissableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupBackBtnTitleView() {
        self.keyboardDismissableView.addSubview(self.backBtnTitleView)
        self.backBtnTitleView.snp.makeConstraints {
            let safeArea = self.view.safeAreaLayoutGuide
            $0.top.equalTo(safeArea).offset(20)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(self.backBtnTitleView.backButtonDiameter)
        }
    }
    
    private func setupDailyHabitView() {
        self.dailyHabitView.do {
            $0.dailyHabitViewPhotoViewDelegate = self
            $0.closeButton.isHidden = true
        }
        
        self.keyboardDismissableView.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalTo(self.backBtnTitleView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupCompleteButton() {
        self.view.addSubview(self.completeButton)
        let safeArea = self.view.safeAreaLayoutGuide
        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.width.equalTo(safeArea)
            $0.height.equalTo(58)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = self.completeButton.backgroundColor
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(self.completeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupHabitStampView() {
        self.habitStampView.delegate = self
        self.habitStampView.dataSource = self.viewModel
        self.habitStampView.registerCell(cellType: HabitStampCell.self)
        
        self.view.addSubview(self.habitStampView)
        self.habitStampView.snp.makeConstraints {
            // 간격 값은 디바이스별로 다르게 주기 위해 디바이스의 높이의 0.0615배로 설정합니다.
            let constant = UIScreen.main.bounds.size.height * 0.047
            $0.top.equalTo(self.dailyHabitView.habitTextView.secondBottomLine.snp.bottom).offset(constant)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalTo(self.completeButton.snp.top)
        }
    }
    
    private func setupBackgounndDimColorView() {
        self.view.addSubview(self.backgroundDimView)
        self.backgroundDimView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func updateViewsWithViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        self.backBtnTitleView.update(with: viewModel)
        self.dailyHabitView.update(with: viewModel)
    }
    
    private func bindingButtons() {
        self.backBtnTitleView.backButton.rx.tap.observeOnMain { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: self.disposeBag)
        
        self.completeButton.rx.tap.observeOnMain { [weak self] in
            guard let self = self else { return }
            
            self.viewModel?.update(
                photoImage: self.dailyHabitView.photoImage,
                contentText: self.dailyHabitView.contentText ?? ""
            )
            
            self.completeButton.isUserInteractionEnabled = false
            self.viewModel?.postDailyHabit(completionHandler: { [weak self] dailyHabitResponseModel in
                self?.navigationController?.popViewController(animated: true, completion: {
                    self?.delegate?.update(currentDailyHabitModel: dailyHabitResponseModel)
                })
                
            }, failureHandler: { [weak self] in
                self?.completeButton.isUserInteractionEnabled = true
            })
            
        }.disposed(by: self.disposeBag)
    }
}

extension HabitWritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.habitStampView.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }
        
        if viewModel.isLocked(at: indexPath.row) {
            self.habitStampView.visibleCells.forEach { $0.isUserInteractionEnabled = false }
            self.popupLockViewAndDown(with: indexPath)
        } else {
            guard let habitStampView = collectionView as? HabitStampView else { return }
            guard let habitStampCell = collectionView.cellForItem(at: indexPath) as? HabitStampCell else { return }
            
            viewModel.selectedStampIndex = indexPath.row
            habitStampView.hideCircleCheckViewOfPrevCell()
            habitStampView.prevCheckedCell = habitStampCell
            habitStampCell.showCheckView()
        }
    }
    
    private func popupLockViewAndDown(with indexPath: IndexPath) {
        self.setupLockPopupViewBehindBottom(with: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.popupLockView()
            self.backgroundDimView.isHidden = false
        }, completion: { _ in
            self.animateDownLockPopupView()
        })
    }
    
    private func setupLockPopupViewBehindBottom(with indexPath: IndexPath) {
        if self.lockPopupView == nil {
            self.lockPopupView = self.makeLockPopupView(with: indexPath)
        }
        
        guard let lockPopupView = self.lockPopupView else { return }
        lockPopupView.alpha = 0
        
        self.view.addSubview(lockPopupView)
        lockPopupView.snp.makeConstraints {
            $0.centerX.equalTo(self.habitStampView)
            $0.width.equalTo(214)
            $0.height.equalTo(144)
        }
        
        let behindBottomConstant: CGFloat = 800
        lockPopupView.topAnchorConstraint = lockPopupView.topAnchor.constraint(
            equalTo: self.habitStampView.topAnchor,
            constant: behindBottomConstant
        )
        lockPopupView.topAnchorConstraint?.isActive = true
        self.view.layoutIfNeeded()
    }
    
    private func makeLockPopupView(with indexPath: IndexPath) -> LockView {
        return LockView().then {
            $0.update(image: self.viewModel?.openImageOfLocked(at: indexPath.row))
            $0.update(attributedText: self.viewModel?.lockMessage(at: indexPath.row))
        }
    }
    
    private func popupLockView() {
        guard let lockPopupView = self.lockPopupView else { return }
        
        lockPopupView.topAnchorConstraint?.constant = 20
        lockPopupView.alpha = 1
        self.view.layoutIfNeeded()
    }
    
    private func animateDownLockPopupView() {
        guard let lockPopupView = self.lockPopupView else { return }
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 1.2, animations: {
            let behindBottomConstant: CGFloat = 800
            lockPopupView.topAnchorConstraint?.constant = behindBottomConstant
            lockPopupView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.habitStampView.visibleCells.forEach { $0.isUserInteractionEnabled = true }
            lockPopupView.removeFromSuperview()
            self.lockPopupView = nil
            self.backgroundDimView.isHidden = true
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HabitWritingViewController: DailyHabitViewPhotoViewDelegate {
    func dailyHabitViewDidTapPhotoButton(_ dailyHabitView: DailyHabitView, actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true)
    }
    
    func dailyHabitViewDidPickerFinish(_ dailyHabitView: DailyHabitView) {
        self.dismiss(animated: true)
    }
    
    func dailyHabitViewWillPickerPresent(_ dailyHabitView: DailyHabitView, picker: UIImagePickerController) {
        self.present(picker, animated: true)
    }
}
