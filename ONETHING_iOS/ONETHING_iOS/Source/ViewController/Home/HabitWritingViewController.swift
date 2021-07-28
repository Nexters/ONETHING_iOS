//
//  HabitWritingViewController.swift
//  ONETHING_iOS
//
//  Created by sdean on 2021/07/13.
//

import UIKit

final class HabitWritingViewController: BaseViewController {
    private var backBtnTitleView: BackBtnTitleView!
    private var completeButton: CompleteButton!
    private let dailyHabitView = DailyHabitView()
    private let viewModel = HabitWritingViewModel()
    private let keyboardDismissableView = UIView()
    private let habitStampView = HabitStampView()
    private let rightSwipeGestureRecognizerView = RightSwipeGestureRecognizerView()
    private var lockPopupView: LockView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.addKeyboardDismissTapGesture()
        self.setupKeyboardDismissableView()
        self.setupBackBtnTitleView()
        self.setupDailyHabitView()
        self.setupCompleteButton()
        self.setupHabitStampView()
        self.setupRightSwipeGestureRecognizerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.keyboardDismissableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardDismissableView() {
        self.view.addSubview(self.keyboardDismissableView)
        
        self.keyboardDismissableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupBackBtnTitleView() {
        self.backBtnTitleView = BackBtnTitleView(parentViewController: self)
        self.backBtnTitleView.update(title: "1일차")
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.keyboardDismissableView.addSubview(self.backBtnTitleView)
        self.backBtnTitleView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(54)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(self.backBtnTitleView.backButtonDiameter)
        }
    }
    
    private func setupDailyHabitView() {
        self.keyboardDismissableView.addSubview(self.dailyHabitView)
        self.dailyHabitView.snp.makeConstraints {
            $0.top.equalTo(self.backBtnTitleView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func setupCompleteButton() {
        self.completeButton = CompleteButton(parentViewController: self)
        
        self.view.addSubview(self.completeButton)
        let safeArea = self.view.safeAreaLayoutGuide
        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.width.equalTo(safeArea)
            $0.height.equalTo(63)
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
        self.habitStampView.backgroundColor = .clear
        self.habitStampView.delegate = self
        self.habitStampView.dataSource = viewModel
        self.habitStampView.registerCell(cellType: HabitStampCell.self)
        
        self.view.addSubview(self.habitStampView)
        self.habitStampView.snp.makeConstraints {
            $0.top.equalTo(self.dailyHabitView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalTo(self.completeButton.snp.top)
        }
    }
    
    private func setupRightSwipeGestureRecognizerView() {
        self.view.addSubview(self.rightSwipeGestureRecognizerView)
        self.rightSwipeGestureRecognizerView.parentViewController = self
        
        self.rightSwipeGestureRecognizerView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(self.backBtnTitleView.snp.leading).offset(-10)
        }
    }
}

extension HabitWritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.habitStampView.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let habitStampView = collectionView as? HabitStampView else { return }
        guard let habitStampCell = collectionView.cellForItem(at: indexPath) as? HabitStampCell else { return }
        
        if habitStampCell.isLocked {
            habitStampView.visibleCells.forEach { $0.isUserInteractionEnabled = false }
            self.popupLockViewAndDown(with: habitStampCell)
        } else {
            habitStampView.hideCircleCheckViewOfPrevCell()
            habitStampView.prevCheckedCell = habitStampCell
            habitStampCell.showCheckView()
        }
    }
    
    private func popupLockViewAndDown(with habitStampCell: HabitStampCell) {
        self.setupLockPopupViewBehindBottom(with: habitStampCell)
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.popupLockView()
        }, completion: { _ in
            self.animateDownLockPopupView()
        })
    }
    
    private func setupLockPopupViewBehindBottom(with habitStampCell: HabitStampCell) {
        if self.lockPopupView == nil {
            self.lockPopupView = LockView()
            self.lockPopupView?.update(image: habitStampCell.stampDefaultImageWhenLocked)
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
    
    private func popupLockView() {
        guard let lockPopupView = self.lockPopupView else { return }
        
        lockPopupView.topAnchorConstraint?.constant = 20
        lockPopupView.alpha = 1
        self.view.layoutIfNeeded()
    }
    
    private func animateDownLockPopupView() {
        guard let lockPopupView = self.lockPopupView else { return }
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 2, animations: {
            let behindBottomConstant: CGFloat = 800
            lockPopupView.topAnchorConstraint?.constant = behindBottomConstant
            lockPopupView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.habitStampView.visibleCells.forEach { $0.isUserInteractionEnabled = true }
            lockPopupView.removeFromSuperview()
            self.lockPopupView = nil
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
